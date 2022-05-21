'use strict'
const FlexContract = require('flex-contract');
const crypto = require('crypto');
const THE_THING_ARTIFACT = require('../build/TheThing.output.json');
const FAKE_OWNER_ARTIFACT = require('../build/FakeOwner.output.json');
const IERC721_ARTIFACT = require('../build/IERC721.output.json');

const PROVIDER_URI = 'https://eth-mainnet.alchemyapi.io/v2/Ho1TkarWhfYDe985hBShuCn2N1LHdGNg';
const THE_THING_ADDRESS = '0x' + crypto.randomBytes(20).toString('hex');
const NFT_ADDRESS = '0x1cb1a5e65610aeff2551a50f76a87a7d3fb649c6';
// const NFT_ADDRESS = '0x715132af755d9d3d81ee0acf11e60692719bc415';
const TOKEN_ID = 3606;
// const TOKEN_ID = 1;
const FRAC_VAULT_FACTORY = '0x70D841fa16D8caD638bEff560Ec442c25F293cE8';

(async () => {
    const tt = new FlexContract(THE_THING_ARTIFACT.abi, THE_THING_ADDRESS, { providerURI: PROVIDER_URI });
    const nft = new FlexContract(IERC721_ARTIFACT.abi, NFT_ADDRESS, { eth: tt.eth });
    let owner;
    try {
        owner = await nft.ownerOf(TOKEN_ID).call();
    } catch {
        console.log(false);
        return;
    }
    const r = await tt.doIt({
        nftContract: nft.address,
        tokenId: TOKEN_ID,
        vaultFactory: FRAC_VAULT_FACTORY,
    }).call({
        overrides: {
            [owner]: { code: FAKE_OWNER_ARTIFACT.deployedBytecode },
            [tt.address]: { code: THE_THING_ARTIFACT.deployedBytecode },
        },
        gas: 1e6
    });
    console.log(r);
})();
