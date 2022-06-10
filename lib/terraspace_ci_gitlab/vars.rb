module TerraspaceCiGitlab
  class Vars
    # Interface method. Hash of properties to be stored
    def data
      {
        build_system: "gitlab",   # required
        host: host,
        full_repo: full_repo,
        branch_name: branch_name,
        # urls
        pr_url: pr_url,
        build_url: ENV['CI_PIPELINE_URL'],
        # additional properties
        build_type: ENV['CI_PIPELINE_SOURCE'], # IE: merge_request_event
        pr_number: pr_number,  # set when build_type=pull_request
        sha: sha,
        # additional properties
        commit_message: ENV['CI_COMMIT_MESSAGE'],
        build_id: ENV['CI_PIPELINE_ID'],
        build_number: ENV['CI_PIPELINE_IID'],
      }
    end

    def host
      ENV['CI_SERVER_URL'] || 'https://gitlab.com'
    end

    def pr_url
      "#{host}/#{full_repo}/-/merge_requests/#{pr_number}" if pr_number
    end

    def pr_number
      ENV['CI_MERGE_REQUEST_IID']
    end

    def branch_name
      ENV['CI_COMMIT_REF_NAME']
    end

    def sha
      ENV['CI_COMMIT_SHA']
    end

    def full_repo
      ENV['CI_PROJECT_PATH']
    end
  end
end
