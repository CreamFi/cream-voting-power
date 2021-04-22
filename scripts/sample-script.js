// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require('hardhat');
const addresses = require('./example.json');

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const VotingPowerFactory = await hre.ethers.getContractFactory(
    'CreamVotingPower'
  );
  const VotingPower = await VotingPowerFactory.deploy();

  await VotingPower.deployed();
  console.log('VotingPower deployed to:', VotingPower.address);

  for (let i = 0; i < addresses.length; i++) {
    try {
      const response = await VotingPower.getVotingPower(addresses[i]);
      console.log(`=========${addresses[i]}=========\n${response}`);
    } catch (err) {
      console.log('error:', err);
    }
  }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
