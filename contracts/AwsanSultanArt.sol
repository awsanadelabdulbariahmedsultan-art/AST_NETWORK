// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";

contract AwsanSultanArt is ERC721Enumerable, ERC2981, Ownable {
    string public constant CREATOR = "Eng. Awsan Adel Abdulbari Ahmed Sultan";
    uint256 public constant MAX_NFT_SUPPLY = 45000;

    constructor() ERC721("Awsan Sultan Art", "ASA") Ownable(msg.sender) {
        _setDefaultRoyalty(msg.sender, 1000); // 10% عوائد ثابتة مسجلة للمهندس أوسان
    }

    function _update(address to, uint256 tokenId, address auth) internal override(ERC721Enumerable) returns (address) {
        return super._update(to, tokenId, auth);
    }
    function supportsInterface(bytes4 interfaceId) public view override(ERC721Enumerable, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
