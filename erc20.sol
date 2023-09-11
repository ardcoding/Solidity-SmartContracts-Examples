//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

import "@openzeppelin/contracts@4.6.0/token/ERC20/ERC20.sol";

contract ardblokchain is ERC20{
    mapping(address => uint) time;
    constructor() ERC20("ARD Blokchain","ARD"){
        _mint(msg.sender, 1000*10**decimals());
    }

    function mint(address to, uint amount) public {
        // require(block.timestamp > 9999999)
        _mint(to,amount);
    }

    function burn(address from, uint amount)public{
        _burn(from,amount);
    }

    function transfer(address to,uint amount) public virtual override returns(bool){
        require(block.timestamp - time[_msgSender()] > 86400, "Transfer only once a day");
        time[_msgSender()] = block.timestamp;

        return super.transfer(to, amount);
    }
}






