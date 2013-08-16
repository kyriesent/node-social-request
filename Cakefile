{spawn, exec} = require 'child_process'

build = (watch) ->
  folders = [{o: 'lib', s: 'src'}, 'test', 'testConfig.coffee']
  buildFolder folder, watch for folder in folders

buildFolder = (folder, watch) ->
  if typeof folder is 'string'
    options = ['-c', folder]
  else
    options = ['-c', '-o', folder.o, folder.s]
  if watch is true
    options[0] = '-cw'
  watcher = spawn 'coffee', options
  watcher.stdout.on 'data', (data) ->
    console.log data.toString().trim()
  watcher.stderr.on 'data', (data) ->
    console.log data.toString().trim()
    watcher = spawn 'node_modules\\.bin\\coffee.cmd', options
    watcher.stdout.on 'data', (data) ->
      console.log data.toString().trim()
    watcher.stderr.on 'data', (data) ->
      console.log data.toString().trim()
  watcher.on 'error', (error) ->
    watcher = spawn 'node_modules\\.bin\\coffee.cmd', options
    watcher.stdout.on 'data', (data) ->
      console.log data.toString().trim()
    watcher.stderr.on 'data', (data) ->
      console.log data.toString().trim()

task 'build', 'build the project', (watch) ->
  build false

task 'watch', 'watch the project folders', () ->
  build true
