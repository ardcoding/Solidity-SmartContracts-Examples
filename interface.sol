//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

contract sendEth{
    function send(address payable to, uint amount) private {
        to.transfer(amount);
    }

}

//abstract  gruplandırmak için
//interface