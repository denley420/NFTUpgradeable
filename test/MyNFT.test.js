const { expect } = require("chai");
const { ethers } = require("hardhat");

let NFT, nft, MyNFTV2, mynftv2

describe("MyNFT", () => {
    beforeEach(async () => {
        const [owner, acct1, acct2] = await ethers.getSigners();
        nft = await ethers.getContractFactory("MyNFT");
        NFT = await upgrades.deployProxy(nft, { kind: "uups" });
        await NFT.deployed();
    })

    it("should be able to add Minter", async function () {
        const [owner, acct1] = await ethers.getSigners();
        await NFT.addMinter(acct1.address);
        await NFT.connect(acct1).mint(100);
        expect (await NFT.balanceOf(acct1.address)).to.equal(100);
    })

    it("should be able to remove Minter", async function () {
        const [owner, acct1, acct2] = await ethers.getSigners();
        await NFT.addMinter(acct2.address);
        await NFT.removeMinter(acct2.address);
        await expect(NFT.connect(acct2).mint(100)).to.be.reverted;
    })

    it("should be able to update Metadata URI", async function () {
        const [owner, acct1, acct2] = await ethers.getSigners();
        await NFT.baseMetadataUri('www.google.com/');
        await NFT.addMinter(owner.address);
        await NFT.mint(100);
        expect (await NFT.tokenURI(1)).to.equal('www.google.com/1');
    })

    it("should be able to update Contract URI and View Contract URI", async function () {
        const [owner, acct1, acct2] = await ethers.getSigners();
        await NFT.contractUri('www.facebook.com/');
        expect (await NFT.viewContractUri()).to.equal('www.facebook.com/');
    })
    
    it("should be able to upgrade Contract", async function () {
        const [owner, acct1, acct2] = await ethers.getSigners();
        MyNFTV2 = await ethers.getContractFactory("MyNFTV2");
        mynftv2 = await upgrades.upgradeProxy(NFT.address, MyNFTV2);
        await mynftv2.deployed();
        await mynftv2.addMinter(owner.address);
        await mynftv2.mint(100);
        expect(await mynftv2.balanceOf(owner.address)).to.equal(100);
    })

})