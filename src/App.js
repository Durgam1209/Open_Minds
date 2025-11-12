import React from "react";
import { BrowserRouter as Router, Routes, Route, Link } from "react-router-dom";
import Home from "./pages/Home";
import Disasters from "./pages/Disasters";
import Resources from "./pages/Resources";
import Broadcasts from "./pages/Broadcasts";
import Stats from "./pages/Stats";

function App() {
  return (
    <Router>
      <div style={styles.navbar}>
        <h2 style={{ color: "white" }}>🌐 Disaster Alert</h2>
        <nav>
          <Link style={styles.link} to="/">Home</Link>
          <Link style={styles.link} to="/disasters">Disasters</Link>
          <Link style={styles.link} to="/resources">Resources</Link>
          <Link style={styles.link} to="/broadcasts">Broadcasts</Link>
          <Link style={styles.link} to="/stats">Stats</Link>
        </nav>
      </div>

      <div style={{ padding: "20px" }}>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/disasters" element={<Disasters />} />
          <Route path="/resources" element={<Resources />} />
          <Route path="/broadcasts" element={<Broadcasts />} />
          <Route path="/stats" element={<Stats />} />
        </Routes>
      </div>
    </Router>
  );
}

const styles = {
  navbar: {
    backgroundColor: "#2c3e50",
    padding: "10px 20px",
    display: "flex",
    justifyContent: "space-between",
    alignItems: "center"
  },
  link: {
    color: "white",
    textDecoration: "none",
    margin: "0 10px",
    fontWeight: "bold"
  }
};

export default App;