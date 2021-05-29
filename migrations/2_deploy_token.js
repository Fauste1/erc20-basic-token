const EBT = artifacts.require("EBT")

module.exports = function (deployer) {
    const initialMint = BigInt('10000000000000000000000000') // 10 million, 18 decimals
    deployer.deploy(EBT, "ERC20 Basic Token", "EBT", initialMint);
};
