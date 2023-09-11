//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

struct Player{
    uint8 attack;
    uint8 defence;
}

contract MinigameJam is ERC721, Ownable, ERC721Burnable{
    mapping(uint => Player) public players;
    mapping(uint => bool) public isAdmin;
    uint public playerCount;

    constructor()ERC721("MinigameJam", "MGJ"){}

    function safeMint(address to) public onlyOwner{
        playerCount++;
        uint8 a, uint8 d) = getPowers();
        players[playerCount] = Player(a,d);
        _safeMint(to,playerCount);
    }

    function changeStatus(address minter) external onlyOwner{
        isAdmin[minter] = !isAdmin[minter];
    }

    function getPowers() private view returns(uint8,uint8){
        return(
            uint8(uint256(keccak256(abi.encodePacked(msg.sender, playerCount, block.difficulty))))%100,
            uint8(uint256(keccak256(abi.encodePacked(msg.sender, playerCount, block.timestamp))))%100
        );
    }

    modifier onlyAdmin(){
        require(isAdmin[msg.sender]==true, "You are not admin");
        _;
    }
}