import React, { useEffect, useState } from "react";
import axios from "axios";

function Disasters() {
  const [disasters, setDisasters] = useState([]);
  const [loading, setLoading] = useState(true);
  const BASE_URL = "http://localhost:3001";

  useEffect(() => {
    axios.get(`${BASE_URL}/api/disasters`)
      .then(res => {
        setDisasters(res.data);
        setLoading(false);
      })
      .catch(err => console.error(err));
  }, []);

  if (loading) return <p>Loading disasters...</p>;

  return (
    <div>
      <h2>🌋 Ongoing Disasters</h2>
      <ul>
        {disasters.map((d, i) => (
          <li key={i}>
            <strong>{d.type.toUpperCase()}</strong> in {d.location}  
            — Magnitude: {d.magnitude}, Severity: {d.severity}
          </li>
        ))}
      </ul>
    </div>
  );
}

export default Disasters;