// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract BaseSniper is Ownable {
    using SafeERC20 for IERC20;

    error InsufficientBalance();
    error SnipeFailed();
    error ZeroAddress();
    error NoTokens();

    event Sniped(address indexed target, uint256 ethSpent, bool success);
    event WithdrawnETH(uint256 amount);
    event WithdrawnToken(address indexed token, uint256 amount);

    constructor() Ownable(msg.sender) {}

    receive() external payable {}

    function snipe(address target, bytes calldata payload, uint256 ethValue) external onlyOwner {
        if (address(this).balance < ethValue) revert InsufficientBalance();
        if (target == address(0)) revert ZeroAddress();

        (bool success, ) = target.call{value: ethValue}(payload);
        if (!success) revert SnipeFailed();

        emit Sniped(target, ethValue, success);
    }

    function withdrawETH() external onlyOwner {
        uint256 balance = address(this).balance;
        if (balance == 0) revert InsufficientBalance();
        
        (bool success, ) = payable(msg.sender).call{value: balance}("");
        require(success, "ETH transfer failed");
        
        emit WithdrawnETH(balance);
    }

    function withdrawToken(address tokenAddress) external onlyOwner {
        if (tokenAddress == address(0)) revert ZeroAddress();
        
        IERC20 token = IERC20(tokenAddress);
        uint256 balance = token.balanceOf(address(this));
        if (balance == 0) revert NoTokens();

        token.safeTransfer(msg.sender, balance);
        emit WithdrawnToken(tokenAddress, balance);
    }
}
