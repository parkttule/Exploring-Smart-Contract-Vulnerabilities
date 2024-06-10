// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Roulette {
    uint256 public pastTimestamp;

    function spin() public payable returns (uint256) {
        require(msg.value == 1 ether, "Not Enough");

        uint256 amount;

        if (block.timestamp % 3 == 0) {
            amount = msg.value * 2;
            payable(msg.sender).transfer(amount);
            return amount;
        }

        amount = 0;

        amount = msg.value * 2;
        payable(msg.sender).transfer(amount);
        
        return amount;
    }
}

