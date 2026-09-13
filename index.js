const http = require('http');
const client = require('prom-client');

// Recolectar métricas internas de Node.js
const collectDefaultMetrics = client.collectDefaultMetrics;
collectDefaultMetrics({ register: client.register });

const server = http.createServer(async (req, res) => {
    if (req.url === '/metrics') {
	res.setHeader('Content-Type', client.register.contentType);
        res.end(await client.register.metrics());
     }
        
    else {
	res.statusCode = 200;
        res.end('¡Bienvenido al backend de la App de Zapatillas!\n');
     }
});

server.listen(3000, () => {
  console.log('Servidor de zapatillas corriendo en el puerto 3000');
});
