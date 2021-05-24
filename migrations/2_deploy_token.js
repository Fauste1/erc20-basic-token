const EBT = artifacts.require("EBT");

module.exports = function (deployer) {
    const initialMint = 1000000
    deployer.deploy(EBT, "ERC20 Basic Token", "EBT", initialMint);
};
