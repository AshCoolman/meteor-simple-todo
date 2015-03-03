Tasks = new Mongo.Collection("tasks")
if Meteor.isClient
  Template.body.helpers
    tasks: ->
      Tasks.find {}
  Template.body.events
    'focus .new-class': (e) ->
      console.log e

if Meteor.isServer
  Meteor.startup ->


# code to run on server at startup