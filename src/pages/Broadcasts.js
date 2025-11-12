import React, { useEffect, useState } from "react";
import axios from "axios";

function Broadcasts() {
  const [broadcasts, setBroadcasts] = useState([]);
  const [loading, setLoading] = useState(true);
  const BASE_URL = "http://localhost:3001";

  useEffect(() => {
    axios.get(`${BASE_URL}/api/broadcasts`)
      .then(res => {
        setBroadcasts(res.data.broadcasts);
        setLoading(false);
      })
      .catch(err => console.error(err));
  }, []);

  if (loading) return <p>Loading broadcasts...</p>;

  return (
    <div>
      <h2>📢 Broadcast Messages</h2>
      <ul>
        {broadcasts.length === 0 && <p>No broadcasts yet.</p>}
        {broadcasts.map((b, i) => (
          <li key={i}>
            <strong>{b.message}</strong> — {b.location} ({b.severity})
          </li>
        ))}
      </ul>
    </div>
  );
}

export default Broadcasts;