Tasks = new Mongo.Collection("tasks")
if Meteor.isClient
  Template.body.helpers
    tasks: ->
      Tasks.find {}, sort: {createdAt:-1}

  Template.body.events
    'click .toggle-checked': (e) ->
      Tasks.update @_id, $set: 
          checked: not @checked

    'click .delete': (e) ->
      Tasks.remove @_id

    'submit .new-task': (e) ->
      
      Tasks.insert
        text: e.target.text.value
        createdAt: new Date()

      e.target.text.value = ""

      false

if Meteor.isServer
  Meteor.startup ->


# code to run on server at startup