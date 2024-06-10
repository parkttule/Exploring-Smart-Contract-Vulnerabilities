// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {
    mapping (address => uint256) balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 _amount) public {
        unchecked{
            require(balances[msg.sender] - _amount > 0);
            balances[msg.sender] -= _amount;
            payable(msg.sender).transfer(_amount);
        }
    }

    function balanceOf(address _account) public view returns(uint256) {
        return balances[_account];
    }
}