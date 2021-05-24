const EBT = artifacts.require("EBT");

module.exports = function (deployer) {
    // issue with passing actual supply (mint * 10 ** 18) as a big number
  deployer.deploy(EBT, "ERC20 Basic Token", "EBT", 1000);
};
