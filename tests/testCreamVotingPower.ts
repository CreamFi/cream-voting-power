import { ethers } from "hardhat";
import { expect } from "chai";

const addresses = [
  "0xeB8A4eADd643Ea3873dfecFBa18BD709D3206919",
  "0xe0Ba6c4c82376c76386D1Ca2ae2516Ab18882e3C",
  "0xE32F576578F9aea942226B6A280fbCe93da45638",
  "0x56e0150b3cbb9f191fe360740fcfa2edbd1b3697",
  "0xbbe21151c726F9EEc42516524f58D0057261CC8a",
  "0x6bD48938B9F9Dd02ee3D6dccd0379DDF0af22D38",
  "0xa805cb6907130c0c7F3534Ee2EBc62D806FFB820",
  "0x7dd508a1e4Da1243789B799a480f8B45e58b1B5b",
  "0xB157ba30e3467DdBC844f14F02b4ba741f1d549F",
  "0x6595732468A241312bc307F327bA0D64F02b3c20",
  "0xdd4C3B2860f7C747C4F69414022D5FA7354Eef28",
  "0xC51FA42503942cafa7b1ffc02F0Cd9564189773e",
  "0x0430605323465E26Dc21fBAaA9A1A4Be6ae9d496",
  "0xAdC24d7b630759A3AF7f52716d91299c999a2213",
  "0x5E0b772FC4E58C470CE4551EeF2391A3B5dA5bb4",
  "0x90aBCf1598ed3077861bCFb3B11EFcd1D7277223",
  "0xF800d8407b1488BB6Dc3789c2D45147c25C38AF5",
  "0xB662ACEAF435C5F21568FC138Ab202C6a43FFc13",
  "0x99eb33756a2eAa32f5964A747722c4b59e6aF351",
];

const expectedVotingPower = [
  ethers.BigNumber.from("0"),
  ethers.BigNumber.from("0"),
  ethers.BigNumber.from("0"),
  ethers.BigNumber.from("2331239573888508371"),
  ethers.BigNumber.from("0"),
  ethers.BigNumber.from("36299103120671021478"),
  ethers.BigNumber.from("0"),
  ethers.BigNumber.from("4964545440271829987"),
  ethers.BigNumber.from("0"),
  ethers.BigNumber.from("0"),
  ethers.BigNumber.from("0"),
  ethers.BigNumber.from("0"),
  ethers.BigNumber.from("0"),
  ethers.BigNumber.from("18688768928836377473"),
  ethers.BigNumber.from("3983416420227929984"),
  ethers.BigNumber.from("0"),
  ethers.BigNumber.from("0"),
  ethers.BigNumber.from("0"),
  ethers.BigNumber.from("0"),
];

describe("Token", function () {
  let creamVotingPower: any;

  beforeEach(async function () {
    const CreamVotingPowerFactory = await ethers.getContractFactory("CreamVotingPower");
    creamVotingPower = await CreamVotingPowerFactory.deploy();
  });

  it("print all balances", async function () {
    for (let i = 0; i < addresses.length; i++) {
      const votingPower = await creamVotingPower.balanceOf(addresses[i]);
      // console.log(`=========${addresses[i]}=========`);
      console.log(votingPower.toString());
      expect(votingPower).equals(expectedVotingPower[i]);
    }
  });
});
