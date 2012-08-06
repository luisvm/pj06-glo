set :application, "globasico"
set :repository,  "git@github.com:whizkas/pj06-glo.git"

set :rvm_ruby_string, '1.9.3@rails32'
require "rvm/capistrano"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :user, 'ubuntu'
set :branch, 'master'
set :use_sudo, false
set :deploy_to, "/home/ubuntu/#{application}"
set :deploy_via, :remote_cache

role :web, "50.112.80.62"                          # Your HTTP server, Apache/etc
role :app, "50.112.80.62"                          # This may be the same as your `Web` server
role :db,  "50.112.80.62", :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:

after "deploy", "deploy:bundle_gems"
after "deploy:bundle_gems", "deploy:restart"

namespace :deploy do
  task :bundle_gems do
    run "cd #{deploy_to}/current && bundle install vendor/gems"
  end
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "killall passenger && rvmsudo passenger start -e production -p 80 --user=#{user}"
  end
end
