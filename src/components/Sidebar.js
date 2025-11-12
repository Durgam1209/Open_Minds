import React from "react";
import { Link } from "react-router-dom";
import "./Sidebar.css";

const Sidebar = () => {
  return (
    <div className="sidebar">
      <h2>Disaster Alert</h2>
      <nav>
        <ul>
          <li><Link to="/">Home</Link></li>
          <li><Link to="/disasters">Disasters</Link></li>
          <li><Link to="/broadcasts">Broadcasts</Link></li>
          <li><Link to="/stats">Stats</Link></li>
          <li><Link to="/resources">Resources</Link></li>
        </ul>
      </nav>
    </div>
  );
};

export default Sidebar;