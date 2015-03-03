Tasks = new Mongo.Collection("tasks")
if Meteor.isClient
  Template.body.helpers
    tasks: ->
      findParams = { checked: {$ne: true} } if Session.get 'hideCompleted'
      Tasks.find findParams or {}, sort: { createdAt: -1 }
    incompleteTasks: ->
      Tasks
        .find {checked: {$ne: true}}
        .count()
    msg:
      hideCompleted: 'Hide completed tasks!'

  Template.body.events
    'submit .new-task': (e) ->
      Meteor.call 'addTask', e.target.text.value
      e.target.text.value = ""
      false
    'click .toggle-checked': (e) ->
      Meteor.call 'setChecked', @_id, not @checked
    'click .delete': (e) ->
      Meteor.call 'deleteTask', @_id
    'change .hide-completed input': (e) ->
      Session.set 'hideCompleted', e.target.checked

  Accounts.ui.config 
    passwordSignupFields: 'USERNAME_ONLY'

if Meteor.isServer
  Meteor.startup ->

Meteor.methods
  addTask: (text) ->
    throw new Meteor.Error 'not-authorised' unless Meteor.userId()
    Tasks.insert
      text: e.target.text.value
      createdAt: new Date()
      owner: Meteor.userId()
      username: Meteor.user().username
  deleteTask: (taskId) ->
    Tasks.remove taskId
  setChecked: (taskId, setChecked) ->
    Tasks.update taskId, $set:
      checked: setChecked




# code to run on server at startup