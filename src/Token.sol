// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20("MyToken", "MTN") {
    address public vault;

    constructor() {
        vault = msg.sender;

        _mint(vault, 100);
    }

    modifier onlyVault {
        require(msg.sender == vault, "Only Vault");
        _;
    }

    function mint(address _who, uint256 _amount) external onlyVault {
        _mint(_who, _amount);
    }

    function burn(address _who, uint256 _amount) external onlyVault {
        _burn(_who, _amount);
    }
    
}

contract Vault {
    Token public token;

    constructor() {
        token = new Token();
    }

    function deposit(address _token) external payable {
        Token(_token).mint(msg.sender, msg.value);
    }

    function withdraw(address _token, uint256 _amount) external {
        require(Token(_token).balanceOf(msg.sender) >= _amount, "Not enough");
        
        Token(_token).burn(msg.sender, _amount);
        payable(msg.sender).transfer(_amount);
    }
}
