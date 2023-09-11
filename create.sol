//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;
contract VaultFactory{
    mapping(address => Vault[]) public userVaults;
    function createVault() external{
        Vault vault = new Vault(msg.sender);
        userVaults[msg.sender].push(vault);
    }
    function createVaultWithPayment() external payable {
        Vault vault = (new Vault){value: msg.value}(msg.sender);
        userVaults[msg.sender].push(vault);
    }
}
contract Vault{
    address public owner;
    uint private balance;

    constructor(address _owner) payable{
        owner = _owner;
        balance += msg.value;
    }
    receive() external payable{
        balance += msg.value;
    }
    fallback() external payable{
        balance += msg.value;
    }
    function getBalance() external view returns(uint){
        return balance;
    }
    function deposit() external payable{
        balance += msg.value;
    }

    function withdraw(uint _amount) external{
        require(msg.sender == owner);
        balance -= _amount;
        payable(owner).transfer(_amount); memory storage 
    }
}