// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Token {
    uint256 public totalbalance;
    mapping (address => uint256) balances;

    function deposit() external payable {
        totalbalance += msg.value;
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 _amount) external {
        require(balances[msg.sender] > _amount);
        totalbalance -= _amount;
        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
    }
}

contract TokenProxy {
    address public admin;

    mapping (address => uint256) public balances;

    address public logic;
    uint256 public totalbalance;
    

    constructor(address _admin, address _logic) {
        admin = _admin;
        logic = _logic;
    }

    modifier onlyAdmin {
        require(msg.sender == admin, "only admin");
        _;
    } 

    function execute(bytes calldata data) external payable {
        logic.delegatecall(data);
    }

    function setLogic(address _logic) public onlyAdmin {
        logic = _logic;
    }

    receive() external payable {
        logic.delegatecall(abi.encodeWithSignature("deposit()"));
    }

    fallback() external payable {
        logic.delegatecall(abi.encodeWithSignature("deposit()"));
    }
}