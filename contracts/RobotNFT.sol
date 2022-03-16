// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RobotNFT is ERC721, Ownable {
    uint256 mintPrice;
    uint256 totalSupply;
    uint256 maxSupply;
    uint256 maxPerWallet;
    bool isPublicMintEnabled;
    string internal baseTokenUri;
    address payable withdrawWallet;

    mapping(address => uint256) public walletMints;

    constructor () payable ERC721('RobotNFT', 'RNFFT') {
        mintPrice = 0.02 ether;
        totalSupply = 0;
        maxSupply = 1000;
        maxPerWallet = 3;
    }

    function setIsPublicMintEnabled(bool isPublicMintEnabled_) external onlyOwner {
        isPublicMintEnabled = isPublicMintEnabled_;
    }

    function setBaseTokenUri(string calldata baseTokenUri_) external onlyOwner {
        baseTokenUri = baseTokenUri_;
    }

    function tokenURI(uint256 tokenId_) public view override returns (string memory) {
        require(_exists(tokenId_), "Token does not exist!");
        return string(abi.encodePacked(baseTokenUri, Strings.toString(tokenId_), ".json"));
    }

    function withdraw() external onlyOwner {
        (bool success, ) = withdrawWallet.call{ value: address(this).balance }('');
        require(success, "withdraw failed !");
    }

    function mint(uint256 quantity_) public payable {
        require(isPublicMintEnabled, "Minting not enabled");
        require(msg.value == quantity_ * mintPrice, "Insuffient eth");
        require(totalSupply + quantity_ <= maxSupply, "Sold out");
        require(walletMints[msg.sender] + quantity_ <= maxPerWallet, "Exceed max wallet");

        for(uint256 i=0; i<quantity_; i++){
            uint256 newTokenId = totalSupply + 1;
            _safeMint(msg.sender, newTokenId);
            totalSupply++;
        }
    }
}
