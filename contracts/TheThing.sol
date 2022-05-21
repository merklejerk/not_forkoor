// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8;

import "./IFractionalFactory.sol";

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address o) external view returns (uint256);
}

interface IERC721 {
    function ownerOf(uint256) external view returns (address);
    function transferFrom(address,address,uint256) external;
    function setApprovalForAll(address,bool) external;
}

contract FakeOwner {
    function arbCall(address target, bytes memory callData)
        external
        returns (bool s)
    {
        (s,) = target.call(callData);
    }
}

contract TheThing {
    struct Input {
        IERC721 nftContract;
        uint256 tokenId;
        IFractionalFactory vaultFactory;
    }

    function doIt(Input memory input) public returns (bool) {
        FakeOwner owner;
        try
            input.nftContract.ownerOf(input.tokenId)
                returns (address owner_)
        {
            owner = FakeOwner(owner_);
        } catch {
            return false;
        }
        _tryArbCall(
            owner,
            address(input.nftContract),
            abi.encodeCall(IERC721.setApprovalForAll, (address(input.vaultFactory), true))
        );
        _tryArbCall(
            owner,
            address(input.vaultFactory),
            abi.encodeCall(IFractionalFactory.mint, (
                "nft frac",
                "FRAC",
                address(input.nftContract),
                input.tokenId,
                1000 ether,
                10000000000 ether,
                0
            ))
        );
        address newOwner = input.nftContract.ownerOf(input.tokenId);
        IERC20 fracToken = IERC20(newOwner);

        return (fracToken.totalSupply() == 1000 ether)
            && (fracToken.balanceOf(address(owner)) == 1000 ether);
    }

    function _tryArbCall(
        FakeOwner owner,
        address target,
        bytes memory callData
    ) internal {
        if (!owner.arbCall(target, callData)) {
            assembly {
                mstore(0, 0)
                return(0, 32)
            }
        }
    }
}
