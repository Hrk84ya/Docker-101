const express = require('express');
const { Client } = require('pg');
const redis = require('redis');

const app = express();
const PORT = 3000;

const pgClient = new Client({
  connectionString: process.env.DATABASE_URL
});

const redisClient = redis.createClient({
  url: 'redis://redis:6379'
});

app.get('/', async (req, res) => {
  try {
    await redisClient.incr('visits');
    const visits = await redisClient.get('visits');
    res.json({ 
      message: 'Multi-container app running!', 
      visits: parseInt(visits),
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get('/health', (req, res) => {
  res.json({ status: 'healthy' });
});

async function start() {
  await pgClient.connect();
  await redisClient.connect();
  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
  });
}

start().catch(console.error);