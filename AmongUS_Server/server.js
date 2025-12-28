const express = require("express");
const crypto = require("crypto");

const app = express();
app.use(express.json());

// =======================
// CONFIG
// =======================
const PORT = 3000;

// =======================
// MOCK TOKEN STORAGE (in memory)
// =======================
const validTokens = new Set();

// =======================
// IN-MEMORY DATA
// =======================
let gameRoom = {
  name: "Battle Royal",
  players: [
    { avatar: "red", username: "Hu5tler", votes: 10 },
    { avatar: "blue", username: "CR7", votes: 20 },
    { avatar: "purple", username: "AKINFENWA", votes: 30 },
    { avatar: "yellow", username: "MC_KILLER", votes: 70 },
    { avatar: "brown", username: "Not_Imposter", votes: 5 }
  ]
};

// =======================
// UTIL – GENERATE MOCK JWT
// =======================
function generateMockToken() {
  return crypto.randomBytes(32).toString("hex");
}

// =======================
// AUTH MIDDLEWARE
// =======================
function authenticate(req, res, next) {
  const token = req.headers["authorization"];

  if (!token || !validTokens.has(token)) {
    return res.status(401).json({ error: "Unauthorized" });
  }

  next();
}

// =======================
// GET /room (PROTECTED)
// =======================
app.get("/room", authenticate, (req, res) => {
  res.status(200).json(gameRoom);
});

// =======================
// POST /addplayer
// =======================
app.post("/addplayer", (req, res) => {
  const { avatar, username } = req.body;

  if (!avatar || !username) {
    return res.status(400).json({ error: "avatar and username required" });
  }

  const newPlayer = {
    avatar,
    username,
    votes: 0
  };

  gameRoom.players.push(newPlayer);

  // Generate & store mock token
  const token = generateMockToken();
  validTokens.add(token);

  res.status(200).json({
    access_token: token
  });
});

// =======================
// START SERVER
// =======================
app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});
