import React, { useEffect, useState } from "react";
import axios from "axios";
import {
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer
} from "recharts";
import { MapContainer, TileLayer, Marker, Popup } from "react-leaflet";
import "leaflet/dist/leaflet.css";
import L from "leaflet";

// 🔴🟡🟢 Marker colors
const icons = {
  high: new L.Icon({
    iconUrl: "https://maps.google.com/mapfiles/ms/icons/red-dot.png",
    iconSize: [32, 32],
  }),
  medium: new L.Icon({
    iconUrl: "https://maps.google.com/mapfiles/ms/icons/yellow-dot.png",
    iconSize: [32, 32],
  }),
  low: new L.Icon({
    iconUrl: "https://maps.google.com/mapfiles/ms/icons/green-dot.png",
    iconSize: [32, 32],
  }),
};

const Stats = () => {
  const [disasterData, setDisasterData] = useState([]);

  // ✅ Fetch from your backend on port 3001
  useEffect(() => {
    axios
      .get("http://localhost:3001/api/disasters")
      .then((res) => setDisasterData(res.data))
      .catch((err) => console.error("Error fetching data:", err));
  }, []);

  // Normalize and aggregate casualties (or similar) by disaster type for the chart.
  // Different backends may call this field differently (casualties, deaths, peopleEvacuated, etc.).
  const getCasualties = (d) => {
    return (
      d.casualties ?? d.deaths ?? d.peopleEvacuated ?? d.peopleEvacuatedCount ?? d.peopleAffected ?? d.affected ?? 0
    );
  };

  const chartData = React.useMemo(() => {
    if (!Array.isArray(disasterData) || disasterData.length === 0) return [];
    const byType = {};
    disasterData.forEach((d) => {
      const type = d.type || "Unknown";
      const val = Number(getCasualties(d)) || 0;
      byType[type] = (byType[type] || 0) + val;
    });
    return Object.keys(byType).map((type) => ({ type, casualties: byType[type] }));
  }, [disasterData]);

  return (
    <div style={styles.container}>
      <h2>📊 Disaster Statistics</h2>

      {/* Graph Section */}
      <div style={styles.section}>
        <h3>Casualties by Disaster Type</h3>
        {disasterData.length > 0 ? (
          <ResponsiveContainer width="100%" height={300}>
            <BarChart data={disasterData}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="type" />
              <YAxis />
              <Tooltip />
              <Legend />
              <Bar dataKey="casualties" fill="#8884d8" name="Casualties" />
            </BarChart>
          </ResponsiveContainer>
        ) : (
          <p>Loading data...</p>
        )}
      </div>

      {/* Map Section */}
      <div style={styles.section}>
        <h3>🗺 Disaster Map (Color Coded)</h3>
        <MapContainer
          center={[20.5937, 78.9629]}
          zoom={5}
          style={{ height: "400px", width: "100%", borderRadius: "10px" }}
        >
          <TileLayer
            url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
            attribution="&copy; OpenStreetMap contributors"
          />
          {disasterData.map((d) => (
            <Marker
              key={d.id}
              position={[d.lat, d.lon]} // your backend uses 'lon' not 'lng'
              icon={
                d.severity === "HIGH"
                  ? icons.high
                  : d.severity === "MEDIUM"
                  ? icons.medium
                  : icons.low
              }
            >
              <Popup>
                <strong>{d.type}</strong><br />
                Location: {d.location}<br />
                Magnitude: {d.magnitude}<br />
                Severity: {d.severity}
              </Popup>
            </Marker>
          ))}
        </MapContainer>
      </div>
    </div>
  );
};

const styles = {
  container: { padding: "20px" },
  section: {
    marginBottom: "40px",
    backgroundColor: "#f9f9f9",
    borderRadius: "12px",
    padding: "20px",
    boxShadow: "0 2px 10px rgba(0,0,0,0.1)",
  },
};

export default Stats;