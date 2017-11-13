var Base = artifacts.require("./Base.sol");
var Request = artifacts.require("Request.sol");

module.exports = function(deployer) {
  deployer.deploy(Base);
};

module.exports = function(deployer) {
  deployer.deploy(Request);
};

