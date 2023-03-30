// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.0/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.0/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.0/contracts/utils/math/SafeMath.sol";

contract SkinMarketplace {
    using SafeMath for uint256;

    IERC20 private _token;
    uint256 private _skinPrice;
    mapping(address => uint256) private _balances;

    constructor(IERC20 token, uint256 skinPrice) {
        _token = token;
        _skinPrice = skinPrice;
    }

    function buySkin(uint256 quantity) external {
        uint256 cost = _skinPrice.mul(quantity);
        require(_token.balanceOf(msg.sender) >= cost, "Insufficient balance");

        _balances[msg.sender] = _balances[msg.sender].add(quantity);
        _token.transferFrom(msg.sender, address(this), cost);
    }

    function sellSkin(uint256 quantity) external {
        require(_balances[msg.sender] >= quantity, "Insufficient balance");
        _balances[msg.sender] = _balances[msg.sender].sub(quantity);
        _token.transfer(msg.sender, _skinPrice.mul(quantity));
    }

    function deposit(uint256 amount) external {
        _token.transferFrom(msg.sender, address(this), amount);
    }

    function withdraw(uint256 amount) external {
        require(_token.balanceOf(address(this)) >= amount, "Insufficient balance");
        _token.transfer(msg.sender, amount);
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    function skinPrice() external view returns (uint256) {
        return _skinPrice;
    }

    function token() external view returns (IERC20) {
        return _token;
    }
}
