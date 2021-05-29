const EBT   = artifacts.require('EBT')
const utils = require('./helpers/utils')

contract('EBT', (accounts) => {
    let     [alice, bob]        = accounts
    let     contractInstance
    
    // Amounts for tests
    const   allowed             = '1000000000000000000'         // 1 token with 18 decimals
    const   initialMint         = '1000000000000000000000000'   // 1 million tokens with 18 decimals
    const   transferAmount      = '1000000000000000000'         // 1 token with 18 decimals

    beforeEach(async () => {
        // We do not specify the contract deployer address, so the test defaults to accounts[0]
        contractInstance = await EBT.new('Erc20 Basic Token', 'EBT', BigInt(initialMint))
    })

    it('should mint an initial supply', async () => {
        const totalSupply = await contractInstance.totalSupply()
        expect(totalSupply.toString()).to.equal(initialMint)
    })

    it('should deposit entire initial mint to contract deployer', async () => {
        const balance = await contractInstance.balanceOf(alice)
        expect(balance.toString()).to.equal(initialMint)
    })

    it('should allow a token transfer', async () => {
        await contractInstance.transfer(bob, BigInt(transferAmount), { from: alice })
        const recipientBalance = await contractInstance.balanceOf(bob)
        expect(recipientBalance.toString()).to.equal(transferAmount)
    })

    it(`should deduct transferred amount from sender's balance`, async () => {
        const initialBalance = await contractInstance.balanceOf(alice)
        await contractInstance.transfer(bob, BigInt(transferAmount), { from: alice })
        const expectedBalance = BigInt(initialBalance.toString()) - BigInt(transferAmount)
        const endBalance = await contractInstance.balanceOf(alice)
        expect(endBalance.toString()).to.equal(expectedBalance.toString())
    })

    // should not allow a 3rd party to initiate a transfer w/o approval
    it(`should not allow 3rd party spending without allowance`, async () => {
        const initialBalance = await contractInstance.balanceOf(alice)
        await utils.shouldThrow(contractInstance.transferFrom(alice, bob, BigInt(transferAmount), { from: bob })) 
        const finalBalance = await contractInstance.balanceOf(alice)
        expect(finalBalance.toString()).to.equal(initialBalance.toString())
    })

    // should allow a spending approval
    it(`should allow user to set an allowance for a 3rd party`, async () => {
        const result = await contractInstance.approve(bob, BigInt(allowed))
        expect(result.receipt.status).to.equal(true)
        const allowance = await contractInstance.allowance(alice, bob)
        expect(allowance.toString()).to.equal(allowed)
    })

    // should allow a 3rd party to initiate a transfer given a sufficient approval
    
    // should not allow to transfer more than what's approved
})