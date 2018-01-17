pragma solidity ^0.4.18;


contract ERC20 {

  uint256 public totalSupply;
  mapping(address => uint256) balancesOf;

  string public name;
  string public symbol;
  uint8 public decimals;

  function ERC20(string _name, string _symbol, uint8 _decimals) public {
    name = _name;
    symbol = _symbol;
    decimals = _decimals;
  }

  function transfer(address to, uint256 value) public returns (bool);
  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  
  
  function balanceOf(address _owner) public view returns (uint256 balance) {
  return balancesOf[_owner];
  }

  event Approval(address indexed owner, address indexed spender, uint256 value);
  event Transfer(address indexed from, address indexed to, uint256 value); 

}
