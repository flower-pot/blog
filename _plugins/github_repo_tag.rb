require 'uri'
require 'open-uri'
require 'net/http'
require 'json'

module Jekyll
  class RenderGitHubRepoTag < Liquid::Tag
    # use in this format: "user/repo"
    def initialize(tag_name, text, tokens)
      super
      uri = URI.parse("https://api.github.com/repos/#{text}".strip)
      req = Net::HTTP::Get.new(uri)
      req.basic_auth ENV['GITHUB_ACCESS_TOKEN'], 'x-oauth-basic'
      http = Net::HTTP.new(uri.hostname, uri.port)
      http.use_ssl = true
      res =  http.request(req)
      json = res.body
      @repo = JSON.parse(json)
    end

    def render(context)
      result =  "<div class='row'>"
      result << "  <div class='clearfix panel panel-default hidden-print col-md-6 col-md-offset-3'>"
      result << "    <div class='panel-body'>"
      result << "      <p class='github-repo-name'><i style='font-size: 120%' class='fa fa-github'> </i> <a href='#{@repo["html_url"]}'>#{@repo["full_name"]}</a> (#{@repo["language"]})</p>"
      result << "      <p class='github-repo-description'>#{@repo["description"]}</p>"
      result << "      <p><a class='btn btn-default pull-left' href='#{@repo["html_url"]}'>Fork <span class='label label-primary'>#{@repo["forks_count"]}</span></a><a class='btn btn-default pull-right' href='#{@repo["html_url"]}'>Watch <span class='label label-primary'>#{@repo["watchers_count"]}</span></a></p>"
      result << "    </div>"
      result << "  </div>"
      result << "</div>"
      result
    end
  end
end

Liquid::Template.register_tag('render_github_repo', Jekyll::RenderGitHubRepoTag)
