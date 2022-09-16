const { parseEther } = require("ethers/lib/utils");

async function deploy_MyNFT(){

  console.log("Deploying MyNFT");
  console.log("------------------------------------------------------");
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  console.log("Account balance:", (await deployer.getBalance()).toString());

  const MyNFT = await ethers.getContractFactory("MyNFT");
  const NFT = await upgrades.deployProxy(MyNFT, { kind: "uups" });
  await NFT.deployed();

  console.log("[MyNFT] address:", NFT.address);

}
deploy_MyNFT().then().catch();