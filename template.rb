
require 'net/http'
require 'base64'
require 'openssl'
require 'json'
if yes?("create .ruby-gemset and .ruby file with #{@app_name} root path? \n >")
  run "rvm gemset create #{@app_name}"
  file '.ruby-gemset', <<-CODE
#{@app_name}
  CODE
  file '.ruby-version', <<-CODE
#{RUBY_VERSION}
  CODE
end
if yes?("add devise gem?(yes/no) \n >")
  uri = URI.parse('https://api.github.com/repos/jdarnok/Gastronautor/contents/config/initializers/devise.rb')
  req = Net::HTTP.new(uri.host, uri.port)
  req.use_ssl = true
  req.verify_mode = OpenSSL::SSL::VERIFY_NONE
  res = req.get(uri.request_uri)
  devise_encoded_content = JSON.parse(res.body)
  devise_content = Base64.decode64(devise_encoded_content['content'])
  gem 'devise'
  initializer 'devise.rb', <<-CODE
  #{devise_content}
  CODE
  after_bundle do
  generate(:devise,'User' )
  end
end
