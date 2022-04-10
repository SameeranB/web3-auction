// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.13;

contract Constants {
    uint256 public AUCTION_BID_DURATION = 2 days;
    uint256 public AUCTION_DECLERATION_DURATION = 1 days;

    uint256 public AUCTION_FEE = 1 ether;
    address public OWNER = address(0x0);
}