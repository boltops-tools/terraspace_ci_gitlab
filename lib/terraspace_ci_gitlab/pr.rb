require "gitlab"

module TerraspaceCiGitlab
  class Pr
    extend Memoist

    def comment(url)
      return unless ENV['CI_PIPELINE_SOURCE'] == 'merge_request_event'
      return unless gitlab_token?

      repo = ENV['CI_PROJECT_PATH'] # org/repo
      number = ENV['CI_MERGE_REQUEST_IID']
      marker = "<!-- terraspace marker -->"
      body = marker + "\n"
      body << "Terraspace Cloud Url #{url}"

      puts "Adding comment to repo #{repo} number #{number}"

      project = client.project(ENV['CI_PROJECT_PATH'])
      merge_request = ENV['CI_MERGE_REQUEST_IID']

      # https://www.rubydoc.info/gems/gitlab/Gitlab/Client/Notes
      # TODO: handle pagination
      notes = client.merge_request_notes(project.id, number)
      # TODO: handle not found. Examples:
      # token is not valid
      # token is not right repo
      # todo are we allow to post comment on public repo without need the permission?
      found_note = notes.find do |note|
        note.body.starts_with?(marker)
      end

      if found_note
        client.edit_merge_request_note(project.id, merge_request, found_note.id, body) unless found_note.body == body
      else
        client.create_merge_request_note(project.id, merge_request, body)
      end
    rescue Gitlab::Error::Unauthorized => e
      puts "WARN: #{e.message}. Unable to create merge request comment. Please double check your gitlab token"
    end

    def client
      Gitlab.configure do |config|
        config.endpoint       = 'https://gitlab.com/api/v4'
        config.private_token  = ENV['GITLAB_TOKEN']
      end
      Gitlab.client
    end
    memoize :client

    def gitlab_token?
      ENV['GITLAB_TOKEN']
    end
  end
end
