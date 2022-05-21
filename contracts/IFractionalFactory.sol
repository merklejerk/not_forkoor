// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8;

interface IFractionalFactory {
    function logic() external view returns (address);

    function mint(
        string calldata _name,
        string calldata _symbol,
        address _token,
        uint256 _id,
        uint256 _supply,
        uint256 _listPrice,
        uint256 _fee
    ) external returns (uint256);

    function owner() external view returns (address);

    function pause() external;

    function paused() external view returns (bool);

    function renounceOwnership() external;

    function settings() external view returns (address);

    function transferOwnership(address newOwner) external;

    function unpause() external;

    function vaultCount() external view returns (uint256);

    function vaults(uint256) external view returns (address);

    function version() external view returns (string memory);
}
