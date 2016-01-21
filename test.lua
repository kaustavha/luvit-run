local runners = require('./main.lua')
local Transform = require('stream').Transform
local Reader = Transform:extend()
function Reader:initialize()
  Transform.initialize(self, {objectMode = true})
end
function Reader:_transform(line, cb) 
  self:push(line)
  cb()
end
require('tap')(function(test)
  test('Test for runStream', function()
    local store = ''
    local cmd = 'echo'
    local reader = Reader:new()
    local child = runners.runStream(cmd, {'foo'})
    child:pipe(reader)
    reader:on('data', function(data)
      store = data
    end)
    reader:once('end', function()
      assert(store == 'foo')
    end)
  end)

  test('Test for run', function()
    runners.run('echo', {'foo'}, {}, function(err, data)
      assert(not next(err))
      assert(data[1] == 'foo')
    end)
  end)
end)