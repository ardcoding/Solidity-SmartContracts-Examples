//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

contract Interact{
    address public caller;
    mapping(address => uint) public counts;
    function call() external{
        caller = msg.sender;
        counts[msg.sender]++;
    }
}

contract Pay {
    mapping(address => uint) public userBalance;

    function payeth(address _payer) external payable {
        // userBalance[msg.sender] += msg.value; msg.sender's address is equal to caller contract's addres in this usage 
        userBalance[_payer] +=msg.value;
    }
}

contract Caller{
    Interact inter;
    
    constructor(address _interContract){
        inter = Interact(_interContract);
    }

    function callInteract() external{
        inter.call();
    }

    function readCaller() external view returns (address){
        return inter.caller();
    }

        function readCallerCount() public view returns (uint){
            return inter.counts(msg.sender);
        }
 
        function payToPay(address _payaddress) public payable{
            Pay pay=Pay(_payaddress);
            pay.payeth{value:msg.value}(msg.sender);

            // Pay(_payaddress).payeth{value:msg.value}(msg.sender); alternative usage
        }

        function sendEthByTransfer() public payable {
            payable(address(inter)).transfer(msg.value);
        }
            uint public reccount = 0;
        receive() external payable{
            reccount+=1;
    }
}
