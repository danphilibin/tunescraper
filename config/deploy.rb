# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'tunescraper'
set :scm, :git
set :repo_url, 'git@github.com:danphilibin/tunescraper.git'

set :deploy_to, '/home/deployer/apps/tunescraper'

set :pty, true

set :format, :pretty

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  desc "Migrate DB"
  task :migrate_db do
    on roles(:app) do
      execute "cd #{current_path} && bundle exec rake db:migrate RAILS_ENV=production"
      execute "touch #{current_path}/tmp/restart.txt"
    end
  end

  desc "Bundle gems"
  task :bundle_install do
    on roles(:app) do
      execute "cd #{current_path} && bundle install"
      execute "touch #{current_path}/tmp/restart.txt"
    end
  end

  desc "Update gems"
  task :bundle_update do
    on roles(:app) do
      execute "cd #{current_path} && bundle update"
      execute "touch #{current_path}/tmp/restart.txt"
    end
  end

  task :copy_database_config do
    on roles(:app) do
      execute "cp ~/config/database.yml #{release_path}/config/database.yml"
      execute "cp ~/config/secrets.yml #{release_path}/config/secrets.yml"
      execute "mkdir #{release_path}/tmp"
    end
  end
end

after 'deploy:updated', 'deploy:copy_database_config', 'deploy:bundle_install', 'deploy:bundle_update'