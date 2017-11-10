//var ConvertLib = artifacts.require("./ConvertLib.sol");
//var MetaCoin = artifacts.require("./MetaCoin.sol");
var CatToken = artifacts.require("./CatToken.sol");

module.exports = function(deployer) {
//  deployer.deploy(ConvertLib);
//  deployer.link(ConvertLib, MetaCoin);
//  deployer.deploy(MetaCoin);
    deployer.deploy(CatToken);
};
