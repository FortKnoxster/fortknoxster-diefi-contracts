const DieFiPolicy = artifacts.require('DieFiPolicy')
const DieFiForwarder = artifacts.require('DieFiForwarder')

module.exports = async function (deployer) {
  await deployer.deploy(DieFiForwarder)
  const forwarder = await DieFiForwarder.deployed()
  await deployer.deploy(DieFiPolicy, forwarder.address)
}