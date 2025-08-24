const express = require('express');
const app = express();
const port = 8080;

function addZero(i) {
  if (i < 10) {i = "0" + i}
  return i;
}

const d = new Date();
let year = d.getFullYear();
let month = addZero(d.getMonth() + 1);
let day = addZero(d.getDate());
let h = addZero(d.getHours());
let m = addZero(d.getMinutes());
let s = addZero(d.getSeconds());
let time = h + ":" + m + ":" + s;
let date = day + "/" + month + "/" + year

app.get('/', (req, res) => {
  res.send({'data': date, 'godzina': time});
});

app.listen(port);




