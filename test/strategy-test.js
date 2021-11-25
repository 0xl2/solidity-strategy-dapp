const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("strategy contract test", () => {
    let contract, owner, account1, account2, account3;

    before(async () => {
        [owner, account1, account2, account3] = await ethers.getSigners();

        const Contract = await ethers.getContractFactory("Strategy");
        contract = await Contract.deploy();
        await contract.deployed();
        console.log("contract deployed to: " + contract.address);
    });

    // everyone can create proposal
    it("create strategy", async() => {
        
    });
});