//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

library Math{

    function plus(uint x, uint y) public pure returns(uint){
        return x+y;
    }

    function minus(uint x, uint y) public pure returns(uint){
        return x-y;
    }

    function multi(uint x, uint y) public pure returns(uint){
        return x*y;
    }

    function divide(uint x, uint y) public pure returns(uint){
        require(y!=0, "can't divided by 0");
        return x/y;
    }

    function min(uint x, uint y) public pure returns(uint){
        if(x<=y){
            return x;
        }
        else{
            return y;
        }
    }

    function max(uint x, uint y) public pure returns(uint){
        if(x>=y){
            return x;
        }
        else{
            return y;
        }
    }
}

library Search{
    function indexOf(uint[] memory list, uint data) public pure returns(uint){
        for(uint i = 0; i<list.length; i++){
            if(list[i]==data){
                return i;
            }
        }
        return list.length;
    }
}


contract Library {
    function result(uint x, uint y) public pure returns(uint){
        return Math.plus(x,y);
    }

    function result2(uint x, uint y) public pure returns(uint){
        return Math.minus(x,y);
    }

    function result3(uint x, uint y) public pure returns(uint){
        return Math.multi(x,y);
    }

    function result4(uint x, uint y) public pure returns(uint){
        return Math.divide(x,y);
    }

    function result5(uint x, uint y) public pure returns(uint){
        return Math.max(x,y);
    }

    function result6(uint x, uint y) public pure returns(uint){
        return Math.min(x,y);
    }
    
    using Math for uint;
    function math1(uint x, uint y) public pure returns(uint){
        return x.plus(y); // another using for return Math.plus(x,y);
    }

    function srch(uint[] memory x, uint y) public pure returns(uint){
        return Search.indexOf(x,y);
    }
}