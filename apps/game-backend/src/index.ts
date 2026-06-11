import express, { Request, Response } from "express";
import cors from "cors";
const app = express();

app.use(express.json());
app.use(cors()); //za test enable sam cors (enabled CORS for local development only) - (in production this would be handled via reverse proxy)//(FE -game-service runs on diffrent port - static is in dist folder)
interface Player {
  player_id: string;
  level: number;
  score: number;
  status: string;
}

const PLAYERS: Record<string, Player> = {
  "12345": {
    player_id: "12345",
    level: 5,
    score: 1250,
    status: "active",
  },
  "67890": {
    player_id: "67890",
    level: 3,
    score: 800,
    status: "active",
  },
};

app.get("/", async (_req: Request, res: Response) => {
  res.json({
    message: "Welcome to Just Slots Demo!",
  });
});

app.get("/health", async (_req: Request, res: Response) => {
  res.json({
    status: "healthy",
    service: "game-backend",
  });
});

app.get(
  "/player/:player_id/stats",
  async (req: Request, res: Response) => {
    const { player_id } = req.params;

    await new Promise((resolve) =>
      setTimeout(resolve, Math.random() * 30)
    );
    const playerId = req.params.player_id as string;
    const player = PLAYERS[playerId];

    if (player) {
      return res.json(player);
    }

    return res.json({
      player_id,
      level: 1,
      score: 0,
      status: "new",
    });
  }
);

app.post("/player/update", async (req: Request, res: Response) => {
  const playerStats = req.body;

  await new Promise((resolve) =>
    setTimeout(resolve, Math.random() * 50)
  );

  PLAYERS[playerStats.player_id] = {
    player_id: playerStats.player_id,
    level: playerStats.level,
    score: playerStats.score,
    status: "active",
  };

  res.json({
    message: "Player data updated successfully",
    player_id: playerStats.player_id,
    updated_level: playerStats.level,
    updated_score: playerStats.score,
  });
});

const PORT = 3000;

app.listen(PORT, () => {
  console.log(`Game backend running on port ${PORT}`);
});
