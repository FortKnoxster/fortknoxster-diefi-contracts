const DieFiPolicy = artifacts.require('DieFiPolicy')
const DieFiForwarder = artifacts.require('DieFiForwarder')

module.exports = async function (deployer, network) {
    if (network == "development") {
        console.log('Skipping migrations "2_deploy_contracts"...')
        return; // test maintains own contracts
    }
    
    console.log('Deploying DieFiForwarder ...')
    await deployer.deploy(DieFiForwarder)
    const forwarder = await DieFiForwarder.deployed()
    console.log('DieFiForwarder deployed ...')

    console.log('Deploying DieFiPolicy ...')
    await deployer.deploy(DieFiPolicy, forwarder.address)
    const policy = await DieFiPolicy.deployed()
    console.log('DieFiPolicy deployed ...')
    await policy.initialize('0xb9015d7B35Ce7c81ddE38eF7136Baa3B1044f313')
    console.log('DieFiPolicy initialized ...')
}