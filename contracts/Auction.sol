// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.13;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./Constants.sol";

contract Auction {

    mapping (IERC721 => mapping (uint256 => AuctionFactory)) public nftToAuction;

    function createAuction(IERC721 nft, uint256 nftId, uint256 startingBid) internal {
        _nft.approve(address(this), nftId);

        AuctionFactory auction = new AuctionFactory(nft, nftId, startingBid);
        nftToNftIds[nft][_nftId] = auction;
    }

    function _verifyAuctionInEndTime(AuctionFactory auction) private view returns (bool) {
        expectedBidTime = auction.startedAt + AUCTION_BID_DURATION;
        expectedEndTime = auction.startedAt + AUCTION_DECLERATION_DURATION;
        return (now >= expectedBidTime && now <= expectedEndTime);
    }

    function _verifyAuctionBids(AuctionFactory auction) private view returns (bool) {
        return (auction.highestBid > 0 && auction.highestBidder != address(0));
    }

    function stopAuction(IERC721 nft, uint256 nftId) internal {
        require(nftToNftIds[nft][nftId].isValue);

        auction = nftToNftIds[nft][nftId];
        _verifyAuctionEndConditions(auction);
        auction.end();
    }

    function _verifyAuctionEndConditions(AuctionFactory auction) private view returns (bool) {
        require(auction.isActive);
        require(_verifyAuctionInEndTime(auction));
        require(_verifyAuctionBids(auction));

    }

    function makeBid(IERC721 nft, uint256 nftId, uint256 bid) internal {
        auction = nftToNftIds[nft][nftId];
        require(_verifyAuctionBidConditions(auction));
        
        auction.addBid(bid);
    }

    function _verifyAuctionBidConditions(AuctionFactory auction) private view returns (bool) {
        require(auction.isActive);
        require(_verifyAuctionInBidTime(auction));
        require(bid > auction.highestBid, "Bid must be higher than current highest bid");    

    }

    function _verifyAuctionInBidTime(AuctionFactory auction) private view returns (bool) {
        expectedBidTime = auction.startedAt + AUCTION_BID_DURATION;
        return (now <= expectedBidTime);
    }

}

contract AuctionFactory {

    IERC721 public nft;
    uint256 public nftId;
    uint256 public startingBid;

    address payable public seller;

    uint256 public startedAt;

    address public highestBidder;
    uint public highestBid;

    address[] public bidders;
    mapping(address => uint) public bids;

    bool isActive;

    constructor(
        IERC721 _nft,
        uint256 _nftId,
        uint256 _startingBid
    ) {
        nft = _nft;
        nftId = _nftId;
        seller = payable(msg.sender);
        highestBid = _startingBid;
        startedAt = now;
        isActive = true;
    }

    function addBid(uint256 bid) internal {
        bidders.push(msg.sender);
        bids[msg.sender] = bid;
        highestBid = bid;
        highestBidder = msg.sender;
    }

    function end() internal {
        nft.safeTransferFrom(seller, highestBidder, nftId);
        OWNER.transfer(highestBid);
        isActive = false;
        returnAllBids();
    }

    function returnAllBids() private {
        for (uint i = 0; i < bidders.length; i++) {
            receiver = bidders[i];
            if (receiver != highestBidder){
                bidValue = bids[receiver];
                receiver.transfer(bidValue);
            }
        }
    }
}