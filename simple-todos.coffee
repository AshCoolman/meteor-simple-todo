Tasks = new Mongo.Collection("tasks")
if Meteor.isClient
  Template.body.helpers
    tasks: ->
      Tasks.find {}
  Template.body.events
    'focus .new-task': (e) ->
      console.log 'focus'
    'submit .new-task': (e) ->
      
      Tasks.insert
        text: e.target.text.value
        createdAt: new Date()

      e.target.text.value = ""

      false

if Meteor.isServer
  Meteor.startup ->


# code to run on server at startup