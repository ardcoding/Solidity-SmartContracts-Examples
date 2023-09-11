//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

contract Multisig{

    uint public nonce;
    uint public requiredConfirmers;

    address[] public signers;

    mapping(uint => Tx) public nonceToTx;
    mapping(uint => mapping(address => bool)) public txConfirmers;

    event newPropose(address propser,uint id);
    event executed(address executor, uint id, bool success);

    struct Tx{
        address proposer;
        uint confirmator;
        bool isExecuted;
        uint timeout;
        address txAddress;
        uint value;
        bytes txData;
    }

    constructor(address[] memory _signers, uint _requiredConfirmers){
        require(_signers.length > 0,"Signers not found");
        require(isUnique(_signers), "Duplicate address");
        require(_requiredConfirmers <= _signers.length,"Not enough signer");

        signers=_signers;
        requiredConfirmers = _requiredConfirmers;
    }

    function propseTx(uint _timeout,address _txAddress,uint _value,bytes memory _txData) external onlySigners{
        require(_timeout > block.timestamp, "Time over");

        Tx memory _tx = Tx({
            proposer: msg.sender,
            confirmator: 0,
            isExecuted: false,
            timeout: _timeout,
            txAddress: _txAddress,
            value: _value,
            txData: _txData
        });

        nonceToTx[nonce] = _tx;
        emit newPropose(msg.sender, nonce);  
        nonce++;
    }

    function confirmTx(uint _nonce) external onlySigners{
        require(_nonce < nonce, "Not exist");
        require(txConfirmers[_nonce][msg.sender] == false, "Already approved");
        require(nonceToTx[_nonce].timeout>block.timestamp, "Time over");
        require(nonceToTx[_nonce].isExecuted==false, "This transaction is executed");

        nonceToTx[_nonce].confirmator++;
        txConfirmers[_nonce][msg.sender] = true;
    }

    function refuseTx(uint _nonce) external onlySigners{
        require(_nonce < nonce, "Not exist");
        require(txConfirmers[_nonce][msg.sender] != false, "Already refused");
        require(nonceToTx[_nonce].timeout>block.timestamp, "Time over");
        require(nonceToTx[_nonce].isExecuted==false, "This transaction is executed");

        nonceToTx[_nonce].confirmator--;
        txConfirmers[_nonce][msg.sender] = false;
    }

    function deleteTx(uint _nonce) external onlySigners{
        require(_nonce < nonce, "Not exist");
        require(nonceToTx[_nonce].isExecuted==false, "This transaction is executed");
        require(nonceToTx[_nonce].proposer == msg.sender, "Sorry, you are not owner");
        require(nonceToTx[_nonce].confirmator< requiredConfirmers, "Already confirmed");

        nonceToTx[_nonce].isExecuted = true;
    }

    function excuteTx(uint _nonce) external onlySigners returns(bool){
        require(_nonce < nonce, "Not exist");
        require(nonceToTx[_nonce].confirmator< requiredConfirmers, "Already confirmed");
        require(nonceToTx[_nonce].isExecuted==false, "This transaction is executed");
        require(nonceToTx[_nonce].value <= address(this).balance);

        nonceToTx[_nonce].isExecuted = true;
        (bool txSuccess, ) = (nonceToTx[_nonce].txAddress).call{value: nonceToTx[_nonce].value}
        (nonceToTx[_nonce].txData);

        if(!txSuccess) nonceToTx[_nonce].isExecuted = false;
        emit executed(msg.sender, _nonce, txSuccess);

        return txSuccess;
    }

    function isUnique(address[] memory arr) private pure returns(bool){

        for(uint i=0; i<arr.length; i++){
            for(uint j = i+1;j<arr.length;j++){
                require(arr[i]!=arr[j],"Duplicate address");
            }
        }
        return true;
    }

    modifier onlySigners(){
        bool signer = false;

        for(uint i = 0; i<signers.length;i++){
            if(signers[i] == msg.sender) signer=true;
        }

        require(signer,"Sorry, You are not signer");
        _;
    }
}