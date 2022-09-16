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

import "erc721a-upgradeable/contracts/ERC721AUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract MyNFT is Initializable, UUPSUpgradeable, ERC721AUpgradeable, OwnableUpgradeable, AccessControlUpgradeable {
        string private _baseUri;
        string private _contractUri;
        bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

        function initialize() initializerERC721A initializer public {
        __ERC721A_init('MyNFT', 'MNFT');
        __Ownable_init();
        __UUPSUpgradeable_init();
        __AccessControl_init();
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

        modifier onlyMinter() {
        require(hasRole(MINTER_ROLE, _msgSender()));
        _;
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyOwner
        override
    {}

    function mint(uint256 quantity) external payable onlyMinter {
        // `_mint`'s second argument now takes in a `quantity`, not a `tokenId`.
        _mint(msg.sender, quantity);
    }

    function baseMetadataUri(string memory _uri) public onlyOwner {
        _baseUri = _uri;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseUri;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControlUpgradeable, ERC721AUpgradeable) returns (bool) {
        // The interface IDs are constants representing the first 4 bytes
        // of the XOR of all function selectors in the interface.
        // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
        // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
        return
            interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
            interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
            interfaceId == 0x5b5e139f || // ERC165 interface ID for ERC721Metadata.
            interfaceId == type(IAccessControlUpgradeable).interfaceId || super.supportsInterface(interfaceId);
    }

    function contractUri(string memory _uri) public onlyOwner {
        _contractUri = _uri;
    }
    
    function viewContractUri() public view virtual returns (string memory) {
        return _contractUri;
    }

    function addMinter(address account) public onlyOwner {
        grantRole(MINTER_ROLE, account);
    }

    function removeMinter(address account) public onlyOwner {
        revokeRole(MINTER_ROLE, account);
    }
    
}
