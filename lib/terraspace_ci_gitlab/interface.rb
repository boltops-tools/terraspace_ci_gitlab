module TerraspaceCiGitlab
  class Interface
    # required interface
    def vars
      Vars.new.data
    end

    def comment(url)
      Pr.new.comment(url)
    end
  end
end
