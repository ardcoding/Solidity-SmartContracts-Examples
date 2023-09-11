// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ardblokchain is ERC1155, Ownable {

    string public name;
    string public symbol;

    constructor() ERC1155("") {
        name="ARD Blokchain";
        symbol="ARD";
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data)
        public
        onlyOwner
    {
        _mint(account, id, amount, data);
    }
}