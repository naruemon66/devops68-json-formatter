const express = require('express');
const app = express();

app.get('/format', (req, res) => {
  const { json } = req.query;
  if (!json) return res.status(400).json({ error: 'Missing json parameter' });
  
  try {
    const parsed = JSON.parse(json);
    const formatted = JSON.stringify(parsed, null, 2);
    res.json({ valid: true, formatted });
  } catch (e) {
    res.status(400).json({ valid: false, error: e.message });
  }
});

app.listen(3026, () => console.log('JSON Formatter API on port 3026'));
