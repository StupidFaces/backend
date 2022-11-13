import * as algosdk from 'algosdk';
import { PrismaClient } from '@prisma/client';

const algodClient = new algosdk.Algodv2('', 'https://node.algoexplorerapi.io/', 443);
const address = "KKBVJLXALCENRXQNEZC44F4NQWGIEFKKIHLDQNBGDHIM73F44LAN7IAE5Q";
const indexerClient = new algosdk.Indexer('', 'https://algoindexer.algoexplorerapi.io/', 443);
const prisma = new PrismaClient();

async function main() {
    const healtState = await indexerClient.makeHealthCheck().do();
    console.info(`Indexer HealthState: ${JSON.stringify(healtState)}`)    

    const accountInfo = await algodClient.accountInformation(address).do();
    const createdAssets = accountInfo['created-assets'];

    for (let asset of createdAssets) {
        const assetUrl = asset['params']['url'];
        const assetId = asset['index'];
        const assetIpfsHash = assetUrl.split('/').at(-1);

        const assetInfo = await indexerClient.lookupAssetByID(assetId).do();
        const assetBlock = await indexerClient.lookupBlock(assetInfo['asset']['created-at-round']).do();
        const assetTimestamp = assetBlock['timestamp'];

        const faceExists = await prisma.stupidFace.findUnique({
            where: {
                assetId: assetId
            }});

        console.info(`${asset['params']['name']} - exists: ${faceExists ? 'true' : 'false'}`);
        
        if(faceExists) continue;
        
        const response = await prisma.stupidFace.create({
            data: {
                assetId: assetId,
                assetName: asset['params']['name'],
                unitName: asset['params']['unit-name'],
                imageUrl: asset['params']['url'],
                ipfsHash: assetIpfsHash,
                blockday: new Date(assetTimestamp * 1e3).toISOString().split('.')[0] + 'Z',
                number: parseInt(asset['params']['name'].split('#').at(-1)),
            }
        })
        console.log(response)
    }
}

main();

export {main}