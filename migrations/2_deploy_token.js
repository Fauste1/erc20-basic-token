const EBT = artifacts.require("EBT")
const web3 = require('web3')

module.exports = function (deployer) {
    const initialMint = web3.utils.toBN('10000000000000000000000000') // 10 million, 18 decimals
    deployer.deploy(EBT, "ERC20 Basic Token", "EBT", initialMint);
};
