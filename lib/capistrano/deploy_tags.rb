module Capistrano
  module DeployTags
    def pending_git_changes?
      # Do we have any changes vs HEAD on deployment branch?
      !(`git fetch && git diff #{branch} --shortstat`.strip.empty?)
    end

    def git_tag_for(stage)
      "#{stage}-#{Time.now.strftime("%Y.%m.%d-%H%M%S")}"
    end

    def safe_run(*args)
      raise "#{args.join(" ")} failed!" unless system(*args)
    end

    def validate_git_vars
      unless exists?(:branch) && exists?(:stage)
        logger.log Capistrano::Logger::IMPORTANT, "Capistrano Deploytags requires that :branch and :stage be defined."
        raise 'define :branch and :stage'
      end
    end

    def git_tag?(tag)
      !`git tag -l #{tag}`.strip.empty?
    end

    def has_remote?
      !`git remote`.strip.empty?
    end

    def self.load_into(configuration)
      configuration.load do
        before "deploy", 'git:prepare_tree'
        before "deploy:migrations", 'git:prepare_tree'
        after  "deploy", 'git:tagdeploy'
        after  "deploy:migrations", 'git:tagdeploy'

        desc 'prepare git tree so we can tag on successful deployment'
        namespace :git do
          task :prepare_tree, :except => { :no_release => true } do
            cdt.validate_git_vars

            logger.log Capistrano::Logger::IMPORTANT, "Preparing to deploy HEAD from branch '#{branch}' to '#{stage}'"

            if cdt.pending_git_changes?
              logger.log Capistrano::Logger::IMPORTANT, "Whoa there, partner. Dirty trees can't deploy. Git yerself clean first."
              raise 'Dirty git tree'
            end

            cdt.safe_run "git", "checkout", branch
            cdt.safe_run "git", "pull", "origin", branch if cdt.has_remote?
          end

          desc 'add git tags for each successful deployment'
          task :tagdeploy, :except => { :no_release => true } do
            cdt.validate_git_vars

            current_sha = `git rev-parse #{branch} HEAD`.strip[0..8]
            logger.log Capistrano::Logger::INFO, "Tagging #{current_sha} for deployment"

            tag_user = (ENV['USER'] || ENV['USERNAME']).strip
            cdt.safe_run "git", "tag", "-a", cdt.git_tag_for(stage), "-m", "#{tag_user} deployed #{current_sha} to #{stage}"

            cdt.safe_run "git", "push", "--tags" if cdt.has_remote?
          end
        end

      end
    end
  end
end

Capistrano.plugin :cdt, Capistrano::DeployTags

if Capistrano::Configuration.instance
  Capistrano::DeployTags.load_into(Capistrano::Configuration.instance(:must_exist))
end
