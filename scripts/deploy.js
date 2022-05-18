const hre = require("hardhat");
const ethers = hre.ethers;

async function main() {
  const TimePayment = await ethers.getContractFactory("TimePayment");
  const timePayment = await TimePayment.deploy("0x48714CAbCd1268C9A2F59813eaB88d490FBf8923", "0xe1E676CFE6c4DA9597D1eb3e0C6CFfB465Ad535B", 10000000);

  await timePayment.deployed();
  
  console.log("TokenVesting deployed to address: ", timePayment.address);
  console.log("TokenVesting deployed to block: ", await hre.ethers.provider.getBlockNumber());
  console.log("TokenVesting owner is: ", await (timePayment.provider.getSigner() ).getAddress() );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });