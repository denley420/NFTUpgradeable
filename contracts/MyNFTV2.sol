// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;

/* CORE
## - Create an ERC721A Upgradable Contract
## - Ownable
## - Setup Base Metadata URI
## - Create Contract URI
## - Should have Access Control
## > Minter Role

Batch Minter
## - for the Minters:
##     - mint(address, amount_to_mint)

Through unit test: transfer, ownerOf, balanceOf
*/
import "./MyNFT.sol";
import "erc721a-upgradeable/contracts/ERC721AUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract MyNFTV2 is MyNFT {
        string public _token;
}
