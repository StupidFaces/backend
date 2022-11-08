import { Prisma, PrismaClient } from '@prisma/client';
import express from 'express';

const prisma = new PrismaClient();
const app = express();

app.use(express.json());

app.get('/hodlers', async (req, res) => {
    const hodlers = await prisma.discordHodler.findMany();
    res.json(hodlers);
});

app.get(`/hodler/:id`, async (req, res) => {
    const { id }: { id?: string } = req.params;

    const hodler = await prisma.discordHodler.findUnique({
        where: { uid: Number(id) },
        include: {
            assets: true, // Return all fields
        }
    })
    res.json(hodler);
});

const server = app.listen(3000, () => {
    console.log(`🚀 Server ready at: http://localhost:3000`);
});