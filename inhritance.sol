//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

contract A{
    uint public x;
    uint public y;
    uint public a;
    uint public b;

    function set(uint _x, uint _y) public {
        x = _x;
        y = _y;
    }

    function add(uint _a, uint _b) virtual public { // I use virtual because i will update this function for contract B
        a = _a;
        b = _b;
    }
}

contract B is A {
    uint public z;
    function setZ(uint _z) public {
        z=_z;
    }

    function add(uint _a, uint _b) override public { // override -> actually 2 set functions in contract B so i use override
        a = _a + 5;
        b = _b + 2;
    }
}

contract User{
   bool public isMember;

   function welcomeMessage() public pure virtual returns (string memory){
       return "Hi, welcome user! Please sign up new account.";
   }   
}

contract Member is User{
    function welcomeMessage() public pure override returns(string memory){
        return "Hi, welcome member! Please login your account.";
    }

    function memberMessage(bool isMember) public pure returns(string memory){
        return isMember ? welcomeMessage() : User.welcomeMessage(); 
        // return isMember ? welcomeMessage() : super.welcomeMessage(); alternative usage
    }
}