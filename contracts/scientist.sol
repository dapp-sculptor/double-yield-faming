// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

// Import OpenZeppelin contracts for ERC20, Ownable, ReentrancyGuard
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
// For debugging
import "hardhat/console.sol";

// Main contract definition
contract Scientist is ERC721Enumerable, Ownable, ReentrancyGuard {
    // ---------------- Events definitions ----------------

    event UserBuyScientist(address user);

    // ---------------- Mapping definitions ----------------

    mapping(address => bool) whiteList;

    // ---------------- Variables ----------------

    uint256 public immutable scientistPriceXqtum;
    address public immutable xqtum;
    string private baseTokenURI;

    // ---------------- Constructor ----------------

    constructor(
        string memory _tokenName,
        string memory _tokenSymbol,
        address _xqtum,
        uint256 _price,
        string memory _baseTokenURI
    ) Ownable(_msgSender()) ERC721(_tokenName, _tokenSymbol) {
        xqtum = _xqtum;
        scientistPriceXqtum = _price;
        baseTokenURI = _baseTokenURI;
    }

    // ---------------- Virtual functions ----------------

    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }

    // ---------------- User functions ----------------

    function buyScientist() external nonReentrant {
        IERC20(xqtum).transferFrom(
            msg.sender,
            address(this),
            scientistPriceXqtum
        );
        _mint(msg.sender, totalSupply());
        whiteList[msg.sender] = true;

        emit UserBuyScientist(msg.sender);
    }

    // ---------------- view functions ----------------

    function checkScientist(address _user) public view returns (bool) {
        if (!whiteList[_user]) return false;
        if (balanceOf(_user) == 0) return false;
        return true;
    }
}