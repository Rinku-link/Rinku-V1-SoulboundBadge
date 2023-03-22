// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract Whitelist {

    bytes32 public merkleRoot;

    constructor(bytes32 _merkleRoot) {
        merkleRoot = _merkleRoot;
    }

    function checkInWhitelist() view public returns (bool) {
        bytes32 leaf = keccak256(abi.encode(msg.sender));
        bool verified = MerkleProof.verify(convertAddressToBytes32(msg.sender), merkleRoot, leaf);
        return verified;
    }

    // This is to convert an address to bytes32[] memory to serve as proof for merkel tree
    function convertAddressToBytes32(address input) private pure returns (bytes32[] memory result) {
        bytes20 addrBytes = bytes20(input);
        bytes32 addrBytes32 = bytes32(addrBytes);

        result = new bytes32[](1);
        result[0] = addrBytes32;
        return result;
    }
    
}