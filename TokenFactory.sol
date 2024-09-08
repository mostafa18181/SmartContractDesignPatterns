// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MyToken.sol";
import "@openzeppelin/contracts/proxy/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenFactory is Ownable {
    address[] public allTokens;
    address public proxyAdmin;

    event TokenCreated(address indexed tokenAddress, address indexed owner);

    constructor(address _proxyAdmin) {
        proxyAdmin = _proxyAdmin;
    }

    function createToken(
        uint256 initialSupply,
        uint256 burnRate,
        uint256 maxBurnRate,
        uint256 rewardAmount,
        address[] memory multiSigners,
        uint256 requiredSignatures,
        address logicContract,
        Memento memento
    ) external onlyOwner {
        bytes memory data = abi.encodeWithSignature(
            "initialize(uint256,uint256,uint256,uint256,address[],uint256,Memento)",
            initialSupply,
            burnRate,
            maxBurnRate,
            rewardAmount,
            multiSigners,
            requiredSignatures,
            memento
        );

        TransparentUpgradeableProxy proxy = new TransparentUpgradeableProxy(
            logicContract,
            proxyAdmin,
            data
        );

        allTokens.push(address(proxy));
        emit TokenCreated(address(proxy), msg.sender);
    }

    function getAllTokens() public view returns (address[] memory) {
        return allTokens;
    }
}

