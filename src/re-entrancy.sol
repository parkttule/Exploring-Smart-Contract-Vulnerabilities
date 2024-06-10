//SPDX-License-Identifier :MIT
pragma solidity ^0.8.0;

contract Vault {
mapping(address => uint256) public balances;

function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

function withdraw(uint256 _amount) public {
        require(balances[msg.sender] >= _amount);

        (bool res, ) = payable(msg.sender).call{ value : _amount }("");
        require(res);
        unchecked {
            balances[msg.sender] -= _amount;
        }
    }
}