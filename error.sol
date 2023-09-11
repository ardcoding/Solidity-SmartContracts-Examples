//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

contract Errors{
    uint public totalBalance;
    mapping(address=> uint) public userBalance;
    
    error ExceedingAmount(address user, uint exceedingAmount); // error
    error Refuse(string reason);


    function pay() notZero(msg.value) external payable {
        require(msg.value == 1 ether, "Only pay 1 eth");
        totalBalance+=1 ether;
        userBalance[msg.sender]+=1 ether;
    }

    function withdraw(uint _amount) notZero(_amount) external{

        uint initalBalance=totalBalance;


        // require(userBalance[msg.sender]>=_amount, "Balance is not enough");
        if(userBalance[msg.sender]<_amount){
            // revert("Your balance is not enough");
            revert ExceedingAmount(msg.sender, _amount = userBalance[msg.sender]);
        }
        totalBalance-=_amount;
        userBalance[msg.sender]-=_amount;
        payable(msg.sender).transfer(_amount);

        assert(totalBalance<initalBalance); //using for test, error 
    }

    modifier notZero(uint _amount){
        require(_amount != 0, "You should not 0 eth");
        _;
    }

    receive() external payable{
        revert Refuse("You can't direct paymanet");
    }

    fallback() external payable{
        revert Refuse("You can't direct paymanet");
    }
}