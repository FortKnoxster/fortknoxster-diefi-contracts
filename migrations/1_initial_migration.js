const Migrations = artifacts.require("Migrations");

module.exports = function (deployer, network) {
  console.log('network', network)
  if (network == "development") {
    console.log('Skipping migrations "1_initial_migration"...')
    return; // test maintains own contracts
  }
  deployer.deploy(Migrations);
};
