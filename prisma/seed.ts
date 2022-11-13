import { PrismaClient, Prisma } from '@prisma/client'
import * as importFaces from '../src/build/importFaces'

const prisma = new PrismaClient()

const collections: Prisma.CollectionCreateInput[] = [
    {
        name: 'stupid-face',
        address: 'KKBVJLXALCENRXQNEZC44F4NQWGIEFKKIHLDQNBGDHIM73F44LAN7IAE5Q'
    },
    {
        name: 'unkown-blob',
        address: 'S6ECCRJW52XXRG6YPM3IVLYFSFPVLZHQVTJFDAEHAFWYP6NYQQE2R3VPOA'
    },
    {
        name: 'unknown-origin',
        address: 'TEMNKCHDMOSOVA47BQ33NPIAKYQ2Y2FKAFKHL7FK3NGGHHPEIV7PQLGKXE'
    },
    {
        name: 'unknown-blob',
        address: '33T5UK5JT53UHY47BDVJFVI3B2OUU7IAMVQJHYOWU3N4EQOZLOBTCLSGLE'
    },
]

async function main() {
    console.log(`Start seeding ...`);
    for (const collectionToCreate of collections) {
        const collection = await prisma.collection.create({
            data: collectionToCreate,
        })
        console.log(`Created collection with id: ${collection.uid}`)
    }
    console.log(`Importing Faces ...`);
    importFaces;
    console.log(`Seeding finished.`);
}

main()
    .then(async () => {
        await prisma.$disconnect()
    })
    .catch(async (e) => {
        console.error(e)
        await prisma.$disconnect()
        process.exit(1)
    })