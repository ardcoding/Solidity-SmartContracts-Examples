//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

//triggered fallback

contract Test{
    uint public total;//default:0
    uint public fallbackCounter;
    string public incrementer;


    fallback() external payable{
        fallbackCounter+=1;
    }
    
    function inc(uint _amount, string memory _incrementer) external returns(uint){
        total += _amount;
        incrementer = _incrementer;

         return total;
    }
}

contract Caller{

    function testCall(address _contract,uint _amount,string memory _incrementer) external returns(bool,uint) {
        (bool err, bytes memory res) = _contract.call(abi.encodeWithSignature("inc(uint,string)",_amount, _incrementer));
        uint _total = abi.decode(res,(uint));
        return(err, _total);
    }
 

    function payFallback(address _contract) external payable{
        (bool err,)=_contract.call{value:msg.value}("");

        if(!err) revert();
    }
}