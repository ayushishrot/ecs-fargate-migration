'use strict';

// Minimal dependency-free HTTP service used as the migration target workload.
// Exposes a liveness/readiness endpoint for the ALB target group health check
// and a root route so you can confirm the task is serving behind the load balancer.

const http = require('http');

const PORT = process.env.PORT || 8080;
const RELEASE = process.env.RELEASE || 'dev';

const server = http.createServer((req, res) => {
  if (req.url === '/healthz' || req.url === '/readyz') {
    res.writeHead(200, { 'content-type': 'application/json' });
    res.end(JSON.stringify({ status: 'ok', release: RELEASE }));
    return;
  }

  res.writeHead(200, { 'content-type': 'application/json' });
  res.end(
    JSON.stringify({
      service: 'orders',
      release: RELEASE,
      host: process.env.HOSTNAME || 'unknown',
      time: new Date().toISOString(),
    }),
  );
});

server.listen(PORT, () => {
  console.log(`orders listening on :${PORT} (release=${RELEASE})`);
});

// Graceful shutdown so ECS rolling deploys drain cleanly.
for (const sig of ['SIGTERM', 'SIGINT']) {
  process.on(sig, () => {
    console.log(`received ${sig}, shutting down`);
    server.close(() => process.exit(0));
  });
}
