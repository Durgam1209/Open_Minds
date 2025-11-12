import React from "react";
import { Bar } from "react-chartjs-2";
import {
  Chart as ChartJS,
  BarElement,
  CategoryScale,
  LinearScale,
  Tooltip,
  Legend,
} from "chart.js";

ChartJS.register(BarElement, CategoryScale, LinearScale, Tooltip, Legend);

const GraphSection = () => {
  const data = {
    labels: ["Floods", "Cyclones", "Earthquakes", "Fires"],
    datasets: [
      {
        label: "Reported Cases (2025)",
        data: [25, 18, 12, 9],
        backgroundColor: "rgba(75,192,192,0.6)",
      },
    ],
  };

  const options = {
    responsive: true,
    plugins: { legend: { position: "top" } },
  };

  return <Bar data={data} options={options} />;
};

export default GraphSection;