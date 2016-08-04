# Ensure deploy tasks are loaded before we run
require 'capistrano/deploy'

# Load extra tasks into the deploy namespace
load File.expand_path("../tasks/deploytags.rake", __FILE__)

module CapistranoDeploytags
  class Helper
    def self.git_tag_for(stage)
      "#{stage}-#{formatted_time}"
    end

    def self.formatted_time
      now = if fetch(:deploytag_utc, true)
        Time.now.utc
      else
        Time.now
      end

      now.strftime(fetch(:deploytag_time_format, "%Y.%m.%d-%H%M%S-#{now.zone.downcase}"))
    end

    def self.commit_message(current_sha, stage)
      if fetch(:deploytag_commit_message, false)
        fetch(:deploytag_commit_message)
      else
        tag_user = (ENV['USER'] || ENV['USERNAME'] || 'deployer').strip
        "#{tag_user} deployed #{current_sha} to #{stage}"
      end
    end
  end
end
