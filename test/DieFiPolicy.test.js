const { expect } = require('chai');
const { utils } = require('ethers');
const addMonths = require('date-fns/addMonths')
require('dotenv').config();

const { FORWARDER_CONTRACT, POLICY_CONTRACT, RELAYER_ADDRESS } = process.env

console.log({FORWARDER_CONTRACT, POLICY_CONTRACT, RELAYER_ADDRESS})

// Import utilities from Test Helpers
const { expectEvent, expectRevert } = require('@openzeppelin/test-helpers');

const SHARES = 3 // threshold shares

// Load DieFiPolicy & DieFiForwarder artifacts
const DieFiPolicy = artifacts.require('DieFiPolicy');
const DieFiForwarder = artifacts.require('DieFiForwarder');

function getRandomPolicyId() {
    return utils.hexlify(utils.randomBytes(16));
}

function toEpoch(date) {
    return (date.getTime() / 1000) | 0
}

function getTimestamps(months) {
    const now = new Date()
    const startDate = addMonths(now, months)
    const endDate = addMonths(now, months + months)
    return {
        startTimestamp: toEpoch(startDate),
        endTimestamp: toEpoch(endDate)
    }
}

// https://github.com/pcaversaccio/metatx/blob/main/test/Forwarder.test.js

// Start test block
contract('DieFiPolicy', function(accounts){
    //const WRITER_ROLE = utils.keccak256(utils.toUtf8Bytes("WRITER_ROLE"));
    let policyId, policyOwner, size, startTimestamp, endTimestamp;
    console.log(accounts)
    console.log('DieFiPolicy testing ...', accounts[|])
    before(async function() {
        //this.diefiForwarder = await DieFiForwarder.new({ from: owner });
        this.diefiForwarder = await DieFiForwarder.at(FORWARDER_CONTRACT);
        console.log('DieFiForwarder contract created or loaded ...', this.diefiForwarder.address)
        //this.diefiPolicy = await DieFiPolicy.new(this.diefiForwarder.address, { from: owner });
        this.diefiPolicy = await DieFiPolicy.at(POLICY_CONTRACT)
        console.log('DieFiPolicy contract created or loaded ...', this.diefiPolicy.address)
    })

    // Deploy contract
    beforeEach(async function () {
        // this.fkx_identity = await FKXIDENTITY.new({ from: owner });
        //this.fkx_identity = await FKXIDENTITY.at(CONTRACT_ADDR);
        
        // Disable unnecessary events
        this.diefiPolicy.getPastEvents("allEvents", {fromBlock: 0, toBlock: "latest"})
    });

    describe('Testing `createPolicy` function', function() {
        beforeEach(function() {            
            policyId = getRandomPolicyId()
            policyOwner = owner
            size = SHARES
            timestamps = getTimestamps(2)
            startTimestamp = timestamps.startTimestamp
            endTimestamp = timestamps.startTimendTimestampestamp
            console.log('test', {policyId, policyOwner, size, startTimestamp, endTimestamp})
        });

        it('function `createPolicy` has successfully created policy', async function () {
            const saved = await this.diefiPolicy.createPolicy(policyId, policyOwner, size, startTimestamp, endTimestamp, { from: accounts[1] });
            expectEvent(saved, 'DieFiPolicyCreated', { policyId, policyOwner, size, startTimestamp, endTimestamp });
        });
/*
        it('function `saveMerkleTree` revert on non-owner call', async function () {
            try{
                await this.fkx_identity.saveMerkleTree(merkleRootHash, ipfsAddress, { from: other});
            } catch(error) {
                assert(error, "Expected error on `saveMerkleTree` called by non-owner");
            }
        });

        it('function `saveMerkleTree` revert on invalid IpfsAddress length', async function () {
            merkleRootHash = getRandomMerkleRootHash();
            var invalidIpfsAddress = (getRandomIpfsAddress()).slice(0,-3);

            try{
                await this.fkx_identity.saveMerkleTree(merkleRootHash, invalidIpfsAddress, { from: owner});
            } catch(error) {
                assert(error, "Expected error on `saveMerkleTree` called with invalid IpfsAddress length");
            }
        });

        it('function `saveMerkleTree` unable overwrite existed MerkleRootHash/IPFSAddress', async function () {
            const saved = await this.fkx_identity.saveMerkleTree(merkleRootHash, ipfsAddress, { from: owner });
            expectEvent(saved, 'SavedMerkleTreeEvent', { merkleRootHash, ipfsAddress });

            // Assign new IPFS address for overwriting
            const newIpfsAddress = getRandomIpfsAddress();

            try{
                await this.fkx_identity.saveMerkleTree(merkleRootHash, newIpfsAddress, { from: owner });
            } catch(error) {
                assert(error, "Expected `saveMerkleTree` won't overwrite address");
            }
        });
*/
    });
/*
    describe('Testing `getIpfsAddress` function', function() {
        beforeEach(function() {
            merkleRootHash = getRandomMerkleRootHash();
            ipfsAddress = getRandomIpfsAddress();
        });

        it('function `getIpfsAddress` returns correct IPFS address', async function () {
            await this.fkx_identity.saveMerkleTree(merkleRootHash, ipfsAddress, { from: owner });

            expect(await this.fkx_identity.getIpfsAddress(merkleRootHash)).to.be.equal(ipfsAddress);
        });
        it('function `getIpfsAddress` returns correct IPFS address when called by non-owner', async function () {
            await this.fkx_identity.saveMerkleTree(merkleRootHash, ipfsAddress, { from: owner});

            expect(await this.fkx_identity.getIpfsAddress(merkleRootHash, { from: other })).to.be.equal(ipfsAddress);
        });
    });

    describe('Testing `exists` function', function() {
        beforeEach(function() {
            merkleRootHash = getRandomMerkleRootHash();
            ipfsAddress = getRandomIpfsAddress();
        });

        it('function `exists` returns `true` for existed Merkle Tree record', async function () {
            await this.fkx_identity.saveMerkleTree(merkleRootHash, ipfsAddress, { from: owner });

            expect(await this.fkx_identity.exists(merkleRootHash)).to.be.true;
        });

        it('function `exists` returns `false` for non-existed Merkle Tree record', async function () {
            const merkleRootHashNew = getRandomMerkleRootHash();

            await this.fkx_identity.saveMerkleTree(merkleRootHash, ipfsAddress, { from: owner });

            expect(await this.fkx_identity.exists(merkleRootHashNew)).to.be.false;
        });

        it('function `exists` returns `true` for existed Merkle Tree record for non-owner call', async function () {
            await this.fkx_identity.saveMerkleTree(merkleRootHash, ipfsAddress, { from: owner });

            expect(await this.fkx_identity.exists(merkleRootHash, { from: other })).to.be.true;
        });

        it('function `exists` returns `false` for non-existed Merkle Tree record for non-owner call', async function () {
            const merkleRootHashNew = utils.hexlify(utils.randomBytes(32));

            await this.fkx_identity.saveMerkleTree(merkleRootHash, ipfsAddress, { from: owner });

            expect(await this.fkx_identity.exists(merkleRootHashNew, { from: other })).to.be.false;
        });
    });
    */

});