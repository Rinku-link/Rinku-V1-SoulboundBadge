// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Whitelist.sol";

contract SoulboundBadgeNFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    Whitelist private whitelist;
    bool private mintEnable;

    constructor() ERC721("SoulboundBadgeNFT", "SBN") {
        mintEnable = false;
    }

    function setMintEnable(bool _mintEnable) public onlyOwner {
        mintEnable = _mintEnable;
    }

    function isMintEnabled() public view returns (bool) {
        return mintEnable;
    }

    function mintBadge(
        address recipient,
        string memory tokenURI
    ) public returns (uint256) {
        require(mintEnable, "Minting is disabled");
        bool inWhitelist = whitelist.checkInWhitelist();
        require(inWhitelist, "You need to be in the white list to mint");
        _tokenIds.increment();
        
        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal virtual override {
        require(from == address(0), "Err: token transfer is BLOCKED");
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }
}
