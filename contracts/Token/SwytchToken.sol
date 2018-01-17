pragma solidity ^0.4.11;

import "./Owned.sol";
import './ERC20.sol';


//This is the main Token Contract derived from the other two contracts
contract SwytchToken is Owned, ERC20 {

    mapping (address => bool) public frozenAccount;
    mapping (address => mapping (address => uint256)) allowed;
    event FrozenFunds(address target, bool frozen);

 
    //This is the main token to be pre-populated with all the parameters
	function SwytchToken(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits, address centralAdmin) 
	ERC20 (tokenName,tokenSymbol, decimalUnits ) public {
		totalSupply = initialSupply;
		if (centralAdmin != 0)
			owner = centralAdmin;
		else
			owner = msg.sender;
		balancesOf[owner] = initialSupply;
		totalSupply = initialSupply;	
	}

    //This function is used to tranfer tokens to a particular address 
	function transfer(address _to, uint256 _value) public returns (bool){
    require(!frozenAccount[msg.sender]);
		require(balancesOf[msg.sender] > 0);
		require(balancesOf[msg.sender] >= _value);
		require(_to != address(0)); //check if address is set and non-empty
		require(_value > 0);
		require(balancesOf[_to] + _value >= balancesOf[_to]);
		require(_to != msg.sender);
		balancesOf[msg.sender] -= _value;
		balancesOf[_to] += _value;
		Transfer(msg.sender, _to, _value);
        return true;
	}

	// Send _value amount of tokens from address _from to address _to
    // The transferFrom method is used for a withdraw workflow, allowing contracts to send
    // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
    // fees in sub-currencies; the command should fail unless the _from account has
    // deliberately authorized the sender of the message via some mechanism; we propose
    // these standardized APIs for approval:
    function transferFrom(
         address _from,
         address _to,
         uint256 _amount
     ) public returns (bool success) 
     {
         if (balancesOf[_from] >= _amount
             && allowed[_from][msg.sender] >= _amount
             && _amount > 0
             && balancesOf[_to] + _amount > balancesOf[_to]) {
             balancesOf[_from] -= _amount;
             allowed[_from][msg.sender] -= _amount;
             balancesOf[_to] += _amount;
             return true;
         } else {
             return false;
         }
    }
    
	  

    function freezeAccount(address target, bool freeze) public onlyOwner {
        frozenAccount[target] = freeze;
        FrozenFunds(target, freeze);
    }


    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
     // If this function is called again it overwrites the current allowance with _value.
     function approve(address _spender, uint256 _amount) public returns (bool success) {
         allowed[msg.sender][_spender] = _amount;
        Approval(msg.sender, _spender, _amount);
         return true;
     } 

     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
         return allowed[_owner][_spender];
    }
    
}

