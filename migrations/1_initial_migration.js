var admin=artifacts.require("./Owned.sol");
var erc20=artifacts.require("./ERC20.sol");
var swytchtoken=artifacts.require("./SwytchToken.sol");

module.exports = function(deployer) { 
  deployer.deploy(admin);
  deployer.deploy(erc20);
  deployer.deploy(swytchtoken);
};
