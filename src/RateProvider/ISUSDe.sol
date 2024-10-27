// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

interface ISUSDe {
    function previewRedeem(uint256 shares) external view returns (uint256);
    function totalAssets() external view returns (uint256);
    function totalSupply() external view returns (uint256);
}
