require 'rack'

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  res['Content-Type'] = 'text/html'
  if req.path == '/i/love/app/academy'
    res.write("/i/love/app/academy")
  end
  res.finish
end

Rack::Server.start(
  app: app,
  Port: 3000
)