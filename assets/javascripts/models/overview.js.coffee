class Nutcracker.Models.Overview extends Backbone.Model
  initialize: ->
    clientConnections = _(@get("clusters").pluck("client_connections")).sum()

    serverConnections = 0
    for nodesCollection in @get("clusters").pluck("nodes")
      serverConnections += nodesCollection.serverConnections()

    @set "serverConnections", serverConnections
    @set "clientConnections", clientConnections

  nodes: =>
    new Backbone.Collection(_(@get("clusters").pluck("nodes")).chain()
      .pluck("models")
      .flatten()
      .value()
    )

  clusters: =>
    @get "clusters"

  hosts: =>
    _(@nodes().pluck("hostname")).uniq()

  parse: ( response ) ->
    response.clusters = new Nutcracker.Collections.Clusters response.clusters
    response

  set: ( attributes, options ) ->
    if attributes.clusters? and attributes.clusters not instanceof Nutcracker.Collections.Clusters
      attributes.clusters = new Nutcracker.Collections.Clusters attributes.clusters

    Backbone.Model.prototype.set.call(@, attributes, options)