const express = require('express');

const app = express();
const port = 8080;

app.get('/', (req, res) => {
    const now = new Date();
    res.json({
        date: now.toLocaleDateString(),
        time: now.toLocaleTimeString()
    });
});

app.listen(port, () => {
    console.log(`Server listening on port ${port}`);
});