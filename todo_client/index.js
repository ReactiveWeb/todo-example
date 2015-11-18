var ko = require('knockout')
var reactiveApi=require('reactiveobserver-knockout')

var api=reactiveApi.createReactiveApi(require('./api.gen.js'))

var connection=new reactiveApi.ReactiveConnection("http://"+document.location.host+"/sockjs")
connection.autoReconnect=true

api.connection=connection

var TodoList = function(api) {
  this.api=api
  this.tasks=this.api.tasks.toKoObservableArray()
  this.newTaskName=ko.observable('')
}
TodoList.prototype.addTask=function() {
  this.api.add_task(this.newTaskName())
  this.newTaskName('')
}
TodoList.prototype.removeTask=function(task) {
  this.api.remove_task(task.name)
}
TodoList.prototype.toggleTask = function(task) {
  if(task.done) this.api.task_undone(task.name); else this.api.task_done(task.name)
}

var ViewModel = function() {
  this.lists=[
    new TodoList(api('Todo.List','global')),
    new TodoList(api('Todo.List','session',connection.sessionId))
  ]
}

var viewModel = new ViewModel()

window.viewModel=viewModel

ko.applyBindings(viewModel)