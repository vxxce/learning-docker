const express = require('express');
const server = express()

server.get('/', (req, res) => {
  res.send('nice');
})

server.listen('5000', () => console.log('running on 5000'))
