const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("vote contract test", () => {
    let vote, owner, account1, account2, account3;

    before(async () => {
        [owner, account1, account2, account3] = await ethers.getSigners();

        
    });

    // everyone can create proposal
    it("create proposal", async() => {
        
    });
});