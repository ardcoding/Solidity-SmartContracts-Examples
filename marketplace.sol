// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract NFTMarketplace{
    address public owner;
    uint public idForSale;
    uint public idForAuction;

    struct itemInfo{
        address contractAddress;
        address seller;
        address buyer;
        uint price;
        uint tokenId;
        bool isSold;
    }

    struct saleForAuction{
        address contractAddress;
        address seller;
        address buyer;
        uint startingPrice;
        uint highestOffer;
        uint tokenId;        
        uint timeout;
        bool isSold;
    }

    mapping(uint=>itemInfo) public itemIdForSale;
    mapping(uint=>saleForAuction) public itemIdForAuction;

    constructor(){
        owner=msg.sender;
    }

    function startNFTSale(address _contractAddress,uint _price, uint _tokenId) public{
        IERC721 NFT = IERC721(_contractAddress);
        require(NFT.ownerOf(_tokenId)==msg.sender,"This NFT is not yours");
        NFT.transferFrom(msg.sender, address(this),_tokenId);
        require(NFT.ownerOf(_tokenId)==address(this));
        itemIdForSale[idForSale]=itemInfo(_contractAddress,msg.sender,msg.sender,_price,_tokenId,false);
        idForSale ++;
    }

    function cancelNFTSale(uint id) public{
        itemInfo memory info = itemIdForSale[id];
        IERC721 NFT = IERC721(info.contractAddress);
        require(id < idForSale);
        require(info.seller==msg.sender);
        require(info.isSold==false);
        NFT.transferFrom(address(this),msg.sender,info.tokenId);
        itemIdForSale[id]=itemInfo(address(0),address(0),address(0),0,0,true);
    }

    function startNFTAuction(address _contractAddress, uint _startingPrice, uint _tokenId, uint _timeout) public{
        IERC721 NFT = IERC721(_contractAddress);
        require(NFT.ownerOf(_tokenId)==msg.sender);
        NFT.transferFrom(msg.sender, address(this),_tokenId);
        itemIdForAuction[idForAuction] = saleForAuction(_contractAddress, msg.sender,msg.sender,_startingPrice,0,_tokenId,_timeout,false);
        idForAuction++;
    }

    function finishNFTAuction(uint id) public{
        saleForAuction storage info=itemIdForAuction[id];
        require(id < idForAuction);
        require(msg.sender == info.buyer);
        require(info.isSold == false);
        require(block.timestamp > info.timeout);

        IERC721 NFT=IERC721(info.contractAddress);
        NFT.transferFrom(address(this),info.buyer,info.tokenId);
        uint price = info.highestOffer * 95 / 100;
        payable(info.seller).transfer(price);
        payable(owner).transfer(info.highestOffer - price);
        info.isSold = true ;
    }

    function cancelNFTAuction(uint id) public{
        saleForAuction memory info = itemIdForAuction[id];
        IERC721 NFT = IERC721(info.contractAddress);
        require(id < idForAuction);
        require(info.seller==msg.sender);
        require(info.isSold==false);
        require(info.buyer == msg.sender);
        NFT.transferFrom(address(this),msg.sender,info.tokenId);
        itemIdForAuction[id]=saleForAuction(address(0),address(0),address(0),0,0,0,0,true);
    }

    function buyNFT(uint id) public payable{
        itemInfo storage info=itemIdForSale[id];
        require(id < idForSale);
        require(msg.sender != info.seller);
        require(msg.value==info.price);
        require(info.isSold == false);
        
        IERC721 NFT = IERC721(info.contractAddress);
        NFT.transferFrom(address(this),msg.sender,info.tokenId);
        uint price = msg.value * 95 / 100;
        payable(info.seller).transfer(price);
        payable(owner).transfer(msg.value - price);
        info.buyer = msg.sender;
        info.isSold = true;
    }

    function offer(uint id) public payable{
        saleForAuction storage info = itemIdForAuction[id];
        require(id < idForAuction);
        require(msg.sender != info.seller);
        require(msg.sender != info.buyer);
        require(msg.value >= info.startingPrice);
        require(info.isSold == false);
        require(block.timestamp < info.timeout);

        if(info.seller == info.buyer){
            info.buyer = msg.sender;
            info.highestOffer = msg.value;
        }
        else {
            payable(info.buyer).transfer(info.highestOffer);
            info.buyer = msg.sender;
            info.highestOffer = msg.value;
        }
    }

    function changeOwner(address _newOwner) public { 
        require(owner==msg.sender);
        owner = _newOwner;
    }
}