var Matryx = artifacts.require("./Matryx.sol");
var MatryxBounty = artifacts.require("./MatryxBounty.sol");

module.exports = function(deployer) {
  deployer.deploy(Matryx);
};
