set :application, 'tunescraper'

set :scm, :git
set :repo_url, 'git@github.com:danphilibin/tunescraper.git'
set :branch, "master"
set :deploy_to, '/var/www/app'

set :ssh_options, {
  user: "dan",
  forward_agent: true,
  port: 22
}

set :linked_files, %w{config/database.yml config/config.yml}
set :linked_dirs, %w{bin log tmp vendor/bundle public/system}

set :use_sudo, false

set :rails_env, :production

set :deploy_via, :copy

set :pty, true

set :keep_releases, 5

server "104.131.207.74", roles: [:app, :web, :db], :primary => true

namespace :deploy do

  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join("tmp/restart.txt")
    end
  end

  after :finishing, "deploy:cleanup"

end
