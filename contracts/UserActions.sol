// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.13;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";


/// @title A title that should describe the contract/interface
/// @author The name of the author
/// @notice Explain to an end user what this does
/// @dev Explain to a developer any extra details
contract UserActions {
    function startAuction(uint256 nft, uint256 nftId, uint256 startingBid) external payable {
        require(msg.value == auctionFee);

        _nft = IERC721(nft);
        require(_nft.ownerOf(nftId) == msg.sender);

        createAuction(_nft, nftId, startingBid);
    }

    function endAuction(uint256 nft, uint256 nftId) external {

        _nft = IERC721(nft);
        require(_nft.ownerOf(nftId) == msg.sender);

        stopAuction(_nft, nftId);
    }

    function bid(uint256 nft, uint256 nftId) external payable {
        require(msg.value > 0);

        _nft = IERC721(nft);
        makeBid(_nft, nftId, msg.value);
    }

}
