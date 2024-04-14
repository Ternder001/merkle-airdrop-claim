// SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.9;
// import "solmate/utils/MerkleProofLib.sol";
//import "solmate/tokens/ERC20.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

// contract Merkle is ERC20 {
//     bytes32 root;

//     constructor(bytes32 _root) ERC20("ABEG", "ABG", 18) {
//         root = _root;
//     }

//     mapping(address => bool) public hasClaimed;

//     function claim(
//         address _claimer,
//         uint _amount,
//         bytes32[] calldata _proof
//     ) external returns (bool success) {
//         require(!hasClaimed[_claimer], "already claimed");
//         bytes32 leaf = keccak256(abi.encodePacked(_claimer, _amount));
//         bool verificationStatus = MerkleProofLib.verify(_proof, root, leaf);
//         require(verificationStatus, "not whitelisted");
//         hasClaimed[_claimer] = true;
//         _mint(_claimer, _amount);
//         success = true;
//     }
// }

pragma solidity ^0.8.9;
import "solmate/utils/MerkleProofLib.sol";
import "solmate/tokens/ERC1155.sol";

contract Merkle is ERC1155 {
    bytes32 public root;
    uint256 public totalTokens; // Total tokens to be airdropped
    uint256 public tokensPerAddress; // Tokens per address

    mapping(address => bool) public hasClaimed;

    constructor(
        bytes32 _root,
        uint256 _totalTokens,
        uint256 _tokensPerAddress
    ) ERC1155() {
        root = _root;
        totalTokens = _totalTokens;
        tokensPerAddress = _tokensPerAddress;
    }

    function claim(
        bytes32[] calldata _proof,
        uint256[] calldata _ids,
        uint256[] calldata _amounts
    ) external {
        address recipient = msg.sender;
        require(!hasClaimed[recipient], "Already claimed");

        bytes32 leaf = keccak256(abi.encodePacked(recipient, _ids, _amounts));
        bool verificationStatus = MerkleProofLib.verify(_proof, root, leaf);
        require(verificationStatus, "Not whitelisted");

        hasClaimed[recipient] = true;
        _mintBatch(recipient, _ids, _amounts, "");
    }
}
