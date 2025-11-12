import React, { useEffect, useState } from "react";
import axios from "axios";

function Resources() {
  const [resources, setResources] = useState({});
  const [loading, setLoading] = useState(true);
  const BASE_URL = "http://localhost:3001";

  useEffect(() => {
    axios.get(`${BASE_URL}/api/resources`)
      .then(res => {
        setResources(res.data);
        setLoading(false);
      })
      .catch(err => console.error(err));
  }, []);

  if (loading) return <p>Loading resources...</p>;

  return (
    <div>
      <h2>🚑 Available Resources</h2>
      <ul>
        {Object.entries(resources).map(([key, value]) => (
          <li key={key}>
            <strong>{key}</strong>: {value}
          </li>
        ))}
      </ul>
    </div>
  );
}

export default Resources;