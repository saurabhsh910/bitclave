var Base = artifacts.require("./Base.sol");
var Request = artifacts.require("Request.sol");
var CatToken = artifacts.require("CatToken.sol");
var Offer = artifacts.require("Offer.sol");

module.exports = function(deployer) {
  deployer.deploy(Base);  
  deployer.deploy(Request);
  deployer.deploy(CatToken);
  deployer.deploy(Offer);
};