//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;
/*
Contract 

memory: temporary
storage: stable
calldata: args in the call

-> uint, int, bool etc 
- in the contract -> storage
- in the function -> memory
-> mappings are always define on the contract and they are in the storage

*/

//Examples:
contract DataLocation{
    uint variable; //storage
    function func(uint number /*memory*/) external{}

    mapping(address => uint) balances; // storage

    function func(string calldata str) external{}//read-only
    function func2(string memory str2) external pure{}//changeable
}
//Examples ended


struct Student{
    string name;
    uint age;
    uint mark;
}

contract Lesson{
    mapping(uint=>Student) students; //Storage
    uint totalStudents=0; //Storage

    function addStudent(string calldata name, uint age,uint16 mark)external{
        uint id=totalStudents++;
        students[id]=Student(name,age,mark);
    }

    function updateStudent(uint id, string calldata newName,uint newAge,uint16 newMark) external{
        
        /*
        students[id].name = newName;
        students[id].age = newAge;
        students[id].mark = newMark;

        this usage is correct but we should use below usage because it's more optimized and use less gas
        */
        
        Student storage currentStudent = students[id]; // we used storage because we update contract but if read only we will use memory
        
        currentStudent.name = newName;
        currentStudent.age = newAge;
        currentStudent.mark = newMark;
    }

    function getName(uint id)external view returns(string memory){
        return students[id].name;
    }
}