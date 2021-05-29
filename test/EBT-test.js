const EBT   = artifacts.require('EBT')
const utils = require('./helpers/utils')

contract('EBT', (accounts) => {
    // Deployment variables
    let     [alice, bob]        = accounts
    let     contractInstance
    const   tokenName               = 'ERC20 Basic Token'
    const   tokenSymbol             = 'EBT'
    
    // Amounts for tests
    const   allowed             = '1000000000000000000'         // 1 token with 18 decimals
    const   initialMint         = '1000000000000000000000000'   // 1 million tokens with 18 decimals
    const   transferAmount      = '1000000000000000000'         // 1 token with 18 decimals

    beforeEach(async () => {
        // We do not specify the contract deployer address, so the test defaults to accounts[0]
        contractInstance = await EBT.new(tokenName, tokenSymbol, BigInt(initialMint), { from: alice })
    })

    it(`should return correct token name`, async () => {
        const _tokenName = await contractInstance.name()
        expect(tokenName).to.equal(_tokenName)
    })
    
    it(`should return correct token symbol`, async () => {
        const _tokenSymbol = await contractInstance.symbol()
        expect(tokenSymbol).to.equal(_tokenSymbol)
    })

    it(`should return correct decimals`, async () => {
        const _decimals = await contractInstance.decimals()
        expect(`18`).to.equal(_decimals.toString())
    })

    it('should mint entire specified initial supply', async () => {
        const totalSupply = await contractInstance.totalSupply()
        expect(totalSupply.toString()).to.equal(initialMint)
    })

    it('should deposit entire initial supply to contract deployer', async () => {
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

    it(`should not allow 3rd party spending without allowance`, async () => {
        const initialBalance = await contractInstance.balanceOf(alice)
        await utils.shouldThrow(contractInstance.transferFrom(alice, bob, BigInt(transferAmount), { from: bob }))
        const finalBalance = await contractInstance.balanceOf(alice)
        expect(finalBalance.toString()).to.equal(initialBalance.toString())
    })

    it(`should allow user to set an allowance for a 3rd party`, async () => {
        const result = await contractInstance.approve(bob, BigInt(allowed), { from: alice })
        expect(result.receipt.status).to.equal(true)
        const allowance = await contractInstance.allowance(alice, bob)
        expect(allowance.toString()).to.equal(allowed)
    })

    it(`should allow a 3rd party to initiate a transfer given a sufficient approval`, async () => {
        await contractInstance.approve(bob, BigInt(allowed), { from: alice })
        const result = await contractInstance.transferFrom(alice, bob, BigInt(transferAmount), { from: bob })
        const recipientBalance = await contractInstance.balanceOf(bob)
        expect(result.receipt.status).to.equal(true)
        expect(transferAmount).to.equal(recipientBalance.toString())
    })
    
    it(`should not allow overspending the allowance`, async () => {
        await contractInstance.approve(bob, BigInt(allowed), { from: alice })
        const notApprovedAmount = BigInt(transferAmount) + 1n
        await utils.shouldThrow(contractInstance.transferFrom(alice, bob, notApprovedAmount, { from: bob }))
    })

    // Bob should have 0 balance after fresh contract deployment
    it(`should not allow overspending of own balance`, async () => {
        await utils.shouldThrow(contractInstance.transfer(alice, BigInt(transferAmount), { from: bob }))
    })
})