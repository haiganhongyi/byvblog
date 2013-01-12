util = require 'util'
config = require '../config'
zhsMsg = require '../locale/zhs'
zhtMsg = require '../locale/zht'

module.exports = (req, res, next) ->
  res.locals.dateFormat = require('dateformat');
  res.locals.inspect = util.inspect
    
  pathSec = req._parsedUrl.pathname.split '/'
  if pathSec[1] in config.languages
    pathStart = 2
    language = pathSec[1]
  else
    pathStart = 1
    language = null
  res.locals.language = language
  res.locals.postId = '/' + pathSec.slice(pathStart).join '/'
  
  res.locals.success = ->
    success = req.session.success
    req.session.success = undefined
    success
  res.locals.errors = ->
    error = req.session.error
    req.session.error = undefined
    error
  
  res.locals.langLink = (suffix) ->
    suffix = '/' + language + suffix if (language)
    suffix
  
  res.locals.postTitle = (post) ->
    for content in post.contents
      if content.language is language
        return content.title
    post.contents[0].title
  
  res.locals.label = (text) ->
    if language is 'zht' or not language
      label = zhtMsg[text.toLowerCase()]
    else if language is 'zhs'
      label = zhsMsg[text.toLowerCase()]
    if not label?
      label = text
    label
  
  next()
