namespace :heroku do
  HEROKU_CONFIG_ADD_COMMAND = "heroku config:add HEROKU=true "

  task :config do
    puts "Reading config/application.yml and sending config vars to Heroku..."
    application_config = YAML.load_file('config/application.yml')['production'] rescue {}
    application_config.delete_if { |k, v| v.blank? }

    heroku_env = application_config.map{|k, v| "#{k}=#{v}"}.join(' ')


    puts "Generating and setting a new secret token"
    token = ActiveSupport::SecureRandom.hex(40)#reloads secret token every time you reload vars.... this expires cookies, and kinda sucks
    system "#{HEROKU_CONFIG_ADD_COMMAND}#{heroku_env} SECRET_TOKEN=#{token}"
  end
end
