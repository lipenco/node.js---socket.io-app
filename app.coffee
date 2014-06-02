express = require 'express'
path = require 'path'
app = express()

app.set 'views', path.join __dirname, 'views'
app.set 'view engine', 'jade'
app.use(express.static(path.join __dirname, 'public'))
app.use require('connect-assets')()

app.get '/', (req, res) ->
 res.render 'index'
app.listen(3000)
console.log('Listening on port 3000')
