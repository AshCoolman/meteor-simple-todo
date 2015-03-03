Tasks = new Mongo.Collection("tasks")
if Meteor.isClient
  Template.body.helpers
    tasks: ->
      findParams = { checked: {$ne: true} } if Session.get 'hideCompleted'
      Tasks.find findParams or {}, sort: { createdAt: -1 }
    msg:
      hideCompleted: 'Hide completed tasks!'

  Template.body.events
    'click .toggle-checked': (e) ->
      Tasks.update @_id, $set: 
          checked: not @checked

    'click .delete': (e) ->
      Tasks.remove @_id

    'change .hide-completed input': (e) ->
      Session.set 'hideCompleted', e.target.checked


    'submit .new-task': (e) ->
      Tasks.insert
        text: e.target.text.value
        createdAt: new Date()

      e.target.text.value = ""

      false

if Meteor.isServer
  Meteor.startup ->


# code to run on server at startup