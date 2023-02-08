//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol";

contract Launchpad is Ownable {
    using SafeMath for uint;
    IERC20 public tokenAddress;
    uint public price;
    uint public tokenSold;

    address payable public seller;

    event tokenPurchased(address buyer, uint price, uint tokenValue);

    constructor(IERC20 _tokenAddress, uint _price) {
        tokenAddress = _tokenAddress;
        price = _price;
        seller = payable(_msgSender());
    }

    receive() external payable{}

    function tokenForSale() public view returns(uint) {
        return tokenAddress.allowance(seller, address(this));
    }

    function buy() public payable returns(bool){
        require(_msgSender() != address(0), "Null address can't buy tokens");
        uint _tokenValue = msg.value.mul(price);
        require(_tokenValue <= tokenForSale(), "Remaining tokens less than buing value");

        //transfer ETH to seller address
        seller.transfer(address(this).balance);

        //transfer tokens to buyer
        tokenAddress.transferFrom(seller, _msgSender(), _tokenValue);
    }
}