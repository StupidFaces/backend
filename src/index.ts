import { DiscordHodler, Prisma, PrismaClient, StupidQuote } from '@prisma/client';
import express from 'express';
import axios from 'axios';
import algosdk from 'algosdk';

const prisma = new PrismaClient();
const indexerClient = new algosdk.Indexer('', 'https://algoindexer.algoexplorerapi.io/', 443);
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

app.get('/daily-info/:userDiscordId/:countryCode?', async (req, res) => {
    try {
        const discordHodler = await getDiscordHodler(req.params.userDiscordId);
        console.info(`Daily-Info Request by ${req.params.userDiscordId}`)

        if(!discordHodler) {
            console.info('unauthenticated request.')
            res.sendStatus(404)
        } else {
            const weatherData = await getWeatherData(req.params.countryCode);
            const dailyTransactionsCount = await getDailyTransactionCount(discordHodler);
            const stupidQuote = await getRandomStupidQuote();
    
            const dailyInfo = {
                weather: weatherData,
                dailyTransactions: dailyTransactionsCount,
                stupidQuote: stupidQuote
            }
            res.json(dailyInfo);
        }
    } catch (error) {
        console.error(error);
        res.sendStatus(500)
    }
});

app.post('/daily-info/persist', async (req, res) => {
    console.info(`daily info persist request incoming`);
    console.log(`Trying to persist: ${req.body.authorId}`);
    try {
        const discordHodler = await prisma.discordHodler.update({
                where: {
                    discordId: req.body.authorId
                },
                data: {
                    lastGm: new Date()
                }
            }
        )
        console.log(`persisted.`)
        res.sendStatus(200)
        //console.log(discordHodler);
    } catch (error) {
        //console.error(error);
        console.error(`Error with persisting.`)
        res.sendStatus(500)
    }
});

const server = app.listen(3000, () => {
    console.log(`🚀 Server ready at: http://localhost:3000`);
});

async function getDiscordHodler(discorHodlerdId: string): Promise<DiscordHodler|null> {
    return await prisma.discordHodler.findUnique({
        where: {
            discordId: discorHodlerdId
        }
    });
}

async function getDailyTransactionCount(discordHodler: DiscordHodler): Promise<string|null> {
    if(!discordHodler?.publicKey) return null;

    const now = new Date();
    const yesterday = new Date(now.setDate(now.getDate() - 1));
    const tnxCount = await indexerClient.lookupAccountTransactions(discordHodler.publicKey).afterTime(yesterday.toISOString()).do();

    return tnxCount?.transactions?.length.toString();

}

async function getRandomStupidQuote(): Promise<StupidQuote|null> {
    const stupidQuotes = await prisma.stupidQuote.findMany({include: {stupidFace: true}});

    if(stupidQuotes.length == 0) return null;

    return stupidQuotes[Math.floor(Math.random()*stupidQuotes.length)]
}

async function getWeatherData(countryCode?: string) {
    const geonamesResponse = await axios.get(`https://api.3geonames.org/?randomland=${countryCode || 'yes'}`);

    const regexLatt = /<latt>(.*?)<\/latt>/g;
    const regexLongt = /<longt>(.*?)<\/longt>/g;
    const regexCity = /<city>(.*?)<\/city>/g;
    const regexState = /<state>(.*?)<\/state>/g;
    const latt = regexLatt.exec(geonamesResponse.data)?.at(1);
    const longt = regexLongt.exec(geonamesResponse.data)?.at(1);
    const city = regexCity.exec(geonamesResponse.data)?.at(1) || '';
    const state = regexState.exec(geonamesResponse.data)?.at(1);
    console.log(`Weather data requested:`, JSON.stringify({ latt, longt, city, state }));

    if (!latt || !longt) {
        throw new Error("Lat/Lng not set correctly!");
    }

    if (!process.env.BACKEND_OPENWEATHERMAP_API_KEY) {
        throw new Error("OWM API Key not set!");
    }

    const owmResponse = await axios.get(`https://api.openweathermap.org/data/2.5/weather?lat=${latt}&lon=${longt}&units=metric&appid=${process.env.BACKEND_OPENWEATHERMAP_API_KEY}`);
    const airPolutionResponse = await axios.get(`https://api.openweathermap.org/data/2.5/air_pollution?lat=${latt}&lon=${longt}&appid=${process.env.BACKEND_OPENWEATHERMAP_API_KEY}`);

    return {
        temp: owmResponse.data?.main?.temp,
        humidity: owmResponse.data?.main?.humidity,
        description: owmResponse.data?.weather?.at(0)?.description,
        location: {
            city: city,
            state: state,
            link: `https://maps.google.com/maps/place/${encodeURIComponent(`${latt},${longt}`)}/@${latt},${longt},12z`,
            airPollution: airPolutionResponse.data?.list?.at(0)
        }
    }
}
