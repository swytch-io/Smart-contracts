pragma solidity ^0.4.17;

/**
 * 
 * This contract is used to set admin to the contract 
 * 
 */
    contract Owned {
        address public owner;

        function owned() public{
            owner = msg.sender;
        }

        modifier onlyOwner {
            require(msg.sender == owner);
            _;
        }

        function transferOwnership(address newOwner) onlyOwner public{
            owner = newOwner;
        }
    }