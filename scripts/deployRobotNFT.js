const hre = require("hardhat");

async function main() {

  const RobotNFT = await hre.ethers.getContractFactory("RobotNFT");
  const robotNFT = await RobotNFT.deploy();

  await robotNFT.deployed();

  console.log("RobotNFT deployed to:", robotNFT.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
