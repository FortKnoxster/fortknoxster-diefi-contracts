require('dotenv').config();
const DieFiPolicy = artifacts.require('DieFiPolicy')
const DieFiForwarder = artifacts.require('DieFiForwarder')

const { RELAYER_ADDRESS, SUBSCRIPTION_MANAGER } = process.env

module.exports = async function (deployer, network) {
    if (network == "development") {
        console.log('Skipping migrations "2_deploy_contracts"...')
        return; // test maintains own contracts
    }
    
    console.log('Deploying DieFiForwarder ...')
    await deployer.deploy(DieFiForwarder, RELAYER_ADDRESS)
    const forwarder = await DieFiForwarder.deployed()
    console.log('DieFiForwarder deployed ...')

    console.log('Deploying DieFiPolicy ...')
    await deployer.deploy(DieFiPolicy, forwarder.address, SUBSCRIPTION_MANAGER)
    const policy = await DieFiPolicy.deployed()
    console.log('DieFiPolicy deployed ...')
}