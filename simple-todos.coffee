notTrue = $ne: true

# Reference to monogo collection
Tasks = new Mongo.Collection "tasks"


if Meteor.isClient
  # Manually link client to the 'tasks' mongo collection
  Meteor.subscribe 'tasks'

  # Helpers for the 'body' template
  Template.body.helpers
    tasks: ->
      findParams = if Session.get 'hideCompleted' then checked: notTrue else {}
      Tasks.find findParams, sort: { createdAt: -1 }
    incompleteTasks: ->
      Tasks
        .find checked: notTrue
        .count()
    msg:
      hideCompleted: 'Hide completed tasks!'

  # Events caught by the 'body' template
  Template.body.events
    'submit .new-task': (e) ->
      Meteor.call 'addTask', e.target.text.value
      e.target.text.value = ""
      false

    'click button.toggle-private': (e) ->
      Meteor.call 'setPrivate', @_id, not @private

    'click button.toggle-checked': (e) ->
      Meteor.call 'setChecked', @_id, not @checked

    'click .delete': (e) ->
      Meteor.call 'deleteTask', @_id

    'change .hide-completed input': (e) ->
      Session.set 'hideCompleted', e.target.checked

  # Helpers for the 'task' template
  Template.task.helpers
    isOwner: ->
      @owner is Meteor.userId()
      return true
      
  Accounts.ui.config 
    passwordSignupFields: 'USERNAME_ONLY' # Don't use email

if Meteor.isServer
  # Allow clients to get their private tasks, and/or public tasks
  Meteor.publish 'tasks', ->
    Tasks.find $or: [
        { private: notTrue }
        { owner: @userId }
      ]
  Meteor.startup ->

Meteor.methods
  addTask: (text) ->
    throw new Meteor.Error 'not-authorised' unless Meteor.userId()
    Tasks.insert
      text: text
      createdAt: new Date()
      owner: Meteor.userId()
      username: Meteor.user().username
  deleteTask: (taskId) ->
    task = Tasks.findOne taskId
    throw new Meteor.Error 'not-authorised' if task.owner isnt Meteor.userId() and task.private
    Tasks.remove taskId
  setChecked: (taskId, setChecked) ->
    task = Tasks.findOne taskId
    throw new Meteor.Error 'not-authorised' if task.owner isnt Meteor.userId() and task.private
    Tasks.update taskId, $set:
      checked: setChecked
  setPrivate: (taskId, privateVal) ->
    task = Tasks.findOne taskId
    throw new Meteor.Error 'not-authorised' if task.owner isnt Meteor.userId()
    Tasks.update taskId, $set: {private: privateVal}




# code to run on server at startup