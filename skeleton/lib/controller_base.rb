require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require 'byebug'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req 
    @res = res
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    !!@already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise 'Double Render' if already_built_response?

    res.status = 302
    res.set_header("location", url)
   
    res.finish
    @already_built_response = true
    @session.store_session(res)

  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise 'Double Render' if already_built_response?
    res.set_header('Content-Type', content_type)
    res.write(content)
    @already_built_response = true

    @session.store_session(res)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    path = "views/#{self.class.to_s.underscore}/#{template_name}.html.erb"
    # File.dirname(path)
    # debugger
    file = File.readlines(path)
    # debugger

    content = ERB.new(file.join('')).result(binding)
    render_content(content,'text/html')

  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end

