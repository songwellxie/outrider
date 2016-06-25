var express = require('express')
var os = require('os')
var mongoose = require('mongoose');

var app = express()

mongoose.connect('mongodb://mongo:31100/mydb');

var CntSchema = mongoose.Schema({
  name: String,
  val: String
});

var Cnt = mongoose.model('Cnt', CntSchema);

var reqCnt = 0;

app.get('/', function (req, res) {

  Cnt.find({name: /cnt/}, function (err, c) {
    if (err) console.log(err);
    c.forEach(function(e){  
      reqCnt = e.val;
    })
  });

  res.send('The ' + reqCnt + ' request is handle by ' + os.hostname() + '. @k82 v3')

  reqCnt = parseInt(reqCnt) + 1;

  var cnt = new Cnt({ name: 'cnt', val: reqCnt });
  cnt.save(function (err) {
    if (err) console.log(err);
  });
})

var server = app.listen(3001, function () {

  var host = server.address().address
  var port = server.address().port

  console.log('Example app listening at http://%s:%s', host, port)

  var cnt = new Cnt({ name: 'cnt', val: '1'});
  cnt.save(function (err, c) {
    if (err) console.log(err);
  });
})
