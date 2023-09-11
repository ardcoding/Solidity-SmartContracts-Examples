//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

library Human{
    struct Person{
        uint age;
    }
    function birthday(Person storage _person) public{
        _person.age+=1;
    }

    function showAge(Person storage _person) public view returns(uint){
        return _person.age;
    }
}


contract HumanContract{
    mapping(uint => Human.Person) people;

    function happybirthday(uint _amount) public{
        Human.birthday(people[_amount]);
    }

    function howOldAreU(uint _amount) public view returns(uint){
        return Human.showAge(people[_amount]);
    }
}