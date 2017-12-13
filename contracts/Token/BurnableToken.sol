pragma solidity ^0.4.18;

import './DetailedERC20.sol';
import './BasicToken.sol';

/**
 * 
 * This is the Token that can be irreversibly burned (destroyed).
 */
contract BurnableToken is DetailedERC20, BasicToken {

    event Burn(address indexed burner, uint256 value);

    /**
     * @dev Burns a specific amount of tokens.
     * @param _value The amount of token to be burned.
     */
    function burn(uint256 _value) public {
        require(_value <= balancesOf[msg.sender]);
        // no need to require value <= totalSupply, since that would imply the
        // sender's balance is greater than the totalSupply, which *should* be an assertion failure

        address burner = msg.sender;
        balancesOf[burner] = balancesOf[burner]-_value;
        totalSupply = totalSupply-_value;
        Burn(burner, _value);
    }
}
