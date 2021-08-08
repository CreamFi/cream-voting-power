import { ethers } from "hardhat";

const addresses = [
  "0xeB8A4eADd643Ea3873dfecFBa18BD709D3206919",
  "0xe0Ba6c4c82376c76386D1Ca2ae2516Ab18882e3C",
  "0xE32F576578F9aea942226B6A280fbCe93da45638",
  "0x56e0150b3cbb9f191fe360740fcfa2edbd1b3697",
  "0xbbe21151c726F9EEc42516524f58D0057261CC8a",
  "0x6bD48938B9F9Dd02ee3D6dccd0379DDF0af22D38",
  "0xa805cb6907130c0c7F3534Ee2EBc62D806FFB820"
];

describe("Token", function () {
  let creamVotingPower: any;

  beforeEach(async function () {
    const CreamVotingPowerFactory = await ethers.getContractFactory("CreamVotingPower");
    creamVotingPower = await CreamVotingPowerFactory.deploy();
  });

  it("print all balances", async function () {
    for (let i = 0; i < addresses.length; i++) {
      try {
        const response = await creamVotingPower.balanceOf(addresses[i]);
        console.log(`=========${addresses[i]}=========\n${response}`);
      } catch (err) {
        console.log('error:', err);
      }
    }
  });
});
