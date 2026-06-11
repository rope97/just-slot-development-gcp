import { useState } from "react";

function App() {
  const [data, setData] = useState<any>(null);

  const loadPlayer = async () => {
    const res = await fetch(
      `${import.meta.env.VITE_API_URL}/player/12345/stats`
    );

    const json = await res.json();
    setData(json);
  };

  return (
    <div style={{ padding: 20 }}>
      <h1>Just Slots Client</h1>

      <button onClick={loadPlayer}>
        Load Player
      </button>

      <pre>{JSON.stringify(data, null, 2)}</pre>
    </div>
  );
}

export default App;
