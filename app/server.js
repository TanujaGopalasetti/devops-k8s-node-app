const express = require("express");
const client = require("prom-client");

const app = express();
const port = process.env.PORT || 3000;

// Prometheus metrics (simple)
client.collectDefaultMetrics();

app.get("/metrics", async (req, res) => {
  res.set("Content-Type", client.register.contentType);
  res.end(await client.register.metrics());
});

// small, readable request log
app.use((req, res, next) => {
  const start = Date.now();
  res.on("finish", () => {
    const ms = Date.now() - start;
    console.log(`${req.method} ${req.path} ${res.statusCode} ${ms}ms`);
  });
  next();
});

app.get("/", (req, res) => {
  res.json({
    message: "hello from tiny-web",
    version: process.env.APP_VERSION || "dev"
  });
});

app.get("/healthz", (req, res) => res.send("ok"));

app.listen(port, () => {
  console.log(`tiny-web listening on port ${port}`);
});
