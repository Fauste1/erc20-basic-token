const Token = artifacts.require("Token");

module.exports = function (deployer) {
  deployer.deploy(Token, "ERC20 Basic Token", "EBT", 1000);
};
