pragma solidity ^0.4.18;
contract Greeter{

    string greeting;
    function Greeter() public {
        greeting = "Hello Confiction";
    }
    function getGreeting() public constant returns (string) {
        return greeting;
    }
    function setGreeting(string newGreeting) public {
        greeting = newGreeting;
    }
}