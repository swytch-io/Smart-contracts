var admin=artifacts.require("./Owned.sol");
var detailederc20=artifacts.require("./DetailedERC20.sol");
var erc20=artifacts.require("./ERC20.sol");
var erc20basic=artifacts.require("./ERC20Basic.sol");
var winjittoken=artifacts.require("./WinjitToken.sol");


module.exports = function(deployer) { 
  deployer.deploy(admin);
  deployer.deploy(detailederc20);
  deployer.deploy(erc20);
  deployer.deploy(erc20basic);
  deployer.deploy(winjittoken);
};
