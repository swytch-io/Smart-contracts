pragma solidity ^0.4.18;


import './ERC20Basic.sol';



/**
 * 
 * This is Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {

  mapping(address => uint256) balancesOf;

  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balancesOf[_owner];
  }

}
