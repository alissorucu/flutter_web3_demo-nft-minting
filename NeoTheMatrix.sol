// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

contract NeoTheMatrix is ERC721, Pausable, Ownable, ERC721Burnable {
    constructor() ERC721("NeoTheMatrix", "NEO") {}

    uint256 public mintPrice = 0.002 ether;
    uint8 public maxSupply = 21;
    uint8 private totalSupply = 0;
   

    
    mapping (uint256 => bool) public hasMinted;

    function setHasMinted(uint256 tokenId) private{
        hasMinted[tokenId]=true;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://my-json-server.typicode.com/alissorucu/flutter_web3_demo-nft-minting/tokens/";
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    uint256[] public soldTokens;
    
    function safeMint() public  payable  returns(uint256) {
        require(msg.value >= mintPrice,"not enough ether");
        require(totalSupply < maxSupply,"sold out");
        
        uint256 mintedTokenId = createRandomTokenId();
        
        _safeMint(msg.sender, mintedTokenId);
        
        soldTokens.push(mintedTokenId);

        setHasMinted(mintedTokenId);
        totalSupply++;
        return mintedTokenId;
    }
   


    
    function createRandomTokenId() internal returns(uint256)  {
        uint256 tokenId = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender, msg.value))) % 21;
        while (hasMinted[tokenId]){
            tokenId = (tokenId + 1) % 21;
        }
        return tokenId; 
    } 


    function getSoldTokens() public view returns(uint256[] memory) {
        return soldTokens;
    }


    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function getTotalSupply() public view returns(uint256) {
        return totalSupply;
    }

    function withdraw() public payable onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

}