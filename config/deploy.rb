# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'tunescraper'
set :scm, :git
set :repo_url, 'git@github.com:danphilibin/tunescraper.git'

set :deploy_to, '/home/deployer/apps/tunescraper'

set :pty, true

set :format, :pretty

set :rvm_custom_path, "/home/dan/.rvm"

set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :mkdir, '-p', "#{ release_path }/tmp"
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  desc 'Clear application cache'
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # within release_path do
        # execute :rake, 'cache:clear'
      # end
    end
  end

  desc 'Copy application environment vars'
  task :copy_env_vars do
    on roles(:app) do
      execute "cp ~/config/application.yml #{release_path}/config/application.yml"
    end
  end

  task :migrate do
    on roles(:app) do
      execute "cd #{release_path} && bundle exec rake db:migrate RAILS_ENV=production"
    end
  end

  after :publishing, :restart
  after :publishing, :copy_env_vars
  after :publishing, :migrate
end