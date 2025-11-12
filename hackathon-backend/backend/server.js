// ==================================================
// DISASTER ALERT BACKEND SERVER
// ==================================================

const express = require('express');
const cors = require('cors');
const axios = require('axios');

const app = express();
const PORT = 3001;

// Middleware
app.use(cors());
app.use(express.json());

// In-memory storage
let resources = {
  ambulances: 15,
  shelters: 8,
  rescueTeams: 12,
  foodPackets: 5000,
  waterBottles: 8000,
  medicalKits: 350,
  blankets: 1200
};

let broadcasts = [];

// ==================================================
// ROOT ENDPOINT
// ==================================================
app.get('/', (req, res) => {
  res.json({
    message: 'Disaster Alert Backend API',
    version: '1.0.0',
    status: 'running',
    endpoints: [
      'GET  /api/disasters',
      'GET  /api/social-feed',
      'GET  /api/resources',
      'POST /api/resources/deploy',
      'POST /api/broadcast',
      'GET  /api/broadcasts',
      'GET  /api/stats'
    ],
    timestamp: new Date().toISOString()
  });
});

// ==================================================
// ENDPOINT 1: Get Real-time Disasters
// ==================================================
app.get('/api/disasters', async (req, res) => {
  try {
    console.log('📡 Fetching earthquake data from USGS...');
    
    const response = await axios.get(
      'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson'
    );
    
    console.log(`✅ Received ${response.data.features.length} earthquakes`);
    
    const earthquakes = response.data.features.slice(0, 20).map(eq => ({
      id: eq.id,
      type: 'earthquake',
      location: eq.properties.place,
      magnitude: eq.properties.mag,
      severity: eq.properties.mag >= 5 ? 'HIGH' : 
               eq.properties.mag >= 3 ? 'MEDIUM' : 'LOW',
      lat: eq.geometry.coordinates[1],
      lon: eq.geometry.coordinates[0],
      depth: eq.geometry.coordinates[2],
      time: new Date(eq.properties.time).toLocaleString(),
      tsunami: eq.properties.tsunami === 1,
      url: eq.properties.url
    }));
    
    const mockFloods = [
      {
        id: 'flood-mumbai-' + Date.now(),
        type: 'flood',
        location: 'Mumbai, Maharashtra, India',
        magnitude: 7.5,
        severity: 'HIGH',
        lat: 19.0760,
        lon: 72.8777,
        depth: 0,
        time: new Date().toLocaleString(),
        tsunami: false
      },
      {
        id: 'cyclone-chennai-' + Date.now(),
        type: 'cyclone',
        location: 'Chennai, Tamil Nadu, India',
        magnitude: 8.2,
        severity: 'HIGH',
        lat: 13.0827,
        lon: 80.2707,
        depth: 0,
        time: new Date().toLocaleString(),
        tsunami: false
      }
    ];
    
    const allDisasters = [...earthquakes, ...mockFloods];
    console.log(`✅ Sending ${allDisasters.length} total disasters`);
    
    res.json(allDisasters);
    
  } catch (error) {
    console.error('❌ ERROR:', error.message);
    res.status(500).json({ error: 'Failed to fetch disaster data' });
  }
});

// ==================================================
// ENDPOINT 2: Social Media Feed
// ==================================================
app.get('/api/social-feed', (req, res) => {
  console.log('📱 Fetching social media feed...');
  
  const feed = [
    {
      id: 1,
      user: '@emergency_official',
      text: 'Heavy rainfall alert issued. Evacuate low-lying areas immediately.',
      verified: true,
      isMisinformation: false,
      timestamp: '2 mins ago',
      likes: 1234,
      retweets: 567
    },
    {
      id: 2,
      user: '@panic_spreader',
      text: 'BREAKING: 10.0 earthquake in 5 minutes! RUN!!!',
      verified: false,
      isMisinformation: true,
      timestamp: '5 mins ago',
      likes: 45,
      retweets: 12
    },
    {
      id: 3,
      user: '@weather_dept',
      text: 'Cyclone warning: Storm at 6 PM. Stay indoors.',
      verified: true,
      isMisinformation: false,
      timestamp: '12 mins ago',
      likes: 5678,
      retweets: 2345
    },
    {
      id: 4,
      user: '@fake_news',
      text: 'Government hiding tsunami truth! Share now!!!',
      verified: false,
      isMisinformation: true,
      timestamp: '18 mins ago',
      likes: 89,
      retweets: 34
    },
    {
      id: 5,
      user: '@disaster_mgmt',
      text: 'Rescue teams deployed. Helpline: 1-800-RESCUE.',
      verified: true,
      isMisinformation: false,
      timestamp: '25 mins ago',
      likes: 8901,
      retweets: 4567
    }
  ];
  
  res.json(feed);
});

// ==================================================
// ENDPOINT 3: Resources
// ==================================================
app.get('/api/resources', (req, res) => {
  console.log('🚑 Fetching resources...');
  res.json(resources);
});

app.post('/api/resources/deploy', (req, res) => {
  const { type, quantity, location } = req.body;
  
  if (!resources[type]) {
    return res.status(400).json({ error: 'Invalid resource type' });
  }
  
  if (resources[type] < quantity) {
    return res.status(400).json({ error: 'Insufficient resources' });
  }
  
  resources[type] -= quantity;
  
  res.json({
    success: true,
    message: `Deployed ${quantity} ${type} to ${location}`,
    remaining: resources[type]
  });
});

// ==================================================
// ENDPOINT 4: Broadcast
// ==================================================
app.post('/api/broadcast', (req, res) => {
  const { message, severity, location } = req.body;
  
  if (!message) {
    return res.status(400).json({ error: 'Message required' });
  }
  
  const broadcast = {
    id: 'BC-' + Date.now(),
    message,
    severity: severity || 'MEDIUM',
    location: location || 'All regions',
    timestamp: new Date().toISOString(),
    recipientCount: Math.floor(Math.random() * 10000) + 5000
  };
  
  broadcasts.push(broadcast);
  
  console.log('📢 BROADCAST:', message);
  
  res.json({
    success: true,
    broadcast,
    message: `Alert sent to ${broadcast.recipientCount} citizens`
  });
});

app.get('/api/broadcasts', (req, res) => {
  res.json({ total: broadcasts.length, broadcasts });
});

// ==================================================
// ENDPOINT 5: Statistics
// ==================================================
app.get('/api/stats', (req, res) => {
  res.json({
    totalDisasters: 24,
    highSeverity: 8,
    peopleEvacuated: 12500,
    responseTime: '12 mins',
    rescuesMade: 156,
    sheltersActive: 8,
    broadcastsSent: broadcasts.length
  });
});

// ==================================================
// START SERVER
// ==================================================
app.listen(PORT, () => {
  console.log('='.repeat(50));
  console.log('✅ DISASTER ALERT BACKEND SERVER RUNNING');
  console.log('='.repeat(50));
  console.log(`🌐 Server URL: http://localhost:${PORT}`);
  console.log(`📡 Root: http://localhost:${PORT}/`);
  console.log(`🌋 Disasters: http://localhost:${PORT}/api/disasters`);
  console.log(`📱 Social Feed: http://localhost:${PORT}/api/social-feed`);
  console.log(`🚑 Resources: http://localhost:${PORT}/api/resources`);
  console.log(`📢 Broadcast: http://localhost:${PORT}/api/broadcast`);
  console.log(`📊 Stats: http://localhost:${PORT}/api/stats`);
  console.log('='.repeat(50));
});