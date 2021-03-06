# frozen_string_literal: true
require_relative "../../lib/graphql/version"

module GraphQLSite
  API_DOC_ROOT = "http://www.rubydoc.info/gems/graphql/#{GraphQL::VERSION}/"

  module APIDoc
    def api_doc(input)
      if !input.start_with?("GraphQL")
        ruby_ident = "GraphQL::#{input}"
      else
        ruby_ident = input
      end

      doc_path = ruby_ident
        .gsub("::", "/")                        # namespaces
        .sub(/#(.+)$/, "#\\1-instance_method")  # instance methods
        .sub(/\.(.+)$/, "#\\1-class_method")    # class methods

      %|<a href="#{API_DOC_ROOT}#{doc_path}" target="_blank" title="API docs for #{ruby_ident}"><code>#{input}</code></a>|
    end

    def link_to_img(img_path, img_title)
      full_img_path = "#{@context.registers[:site].baseurl}#{img_path}"
      %|
        <a href="#{full_img_path}" target="_blank">
          <img src="#{full_img_path}" title="#{img_title}" alt="#{img_title}" />
        </a>
      |
    end
  end

  class APIDocRoot < Liquid::Tag
    def render(context)
      API_DOC_ROOT
    end
  end
end



Liquid::Template.register_filter(GraphQLSite::APIDoc)
Liquid::Template.register_tag("api_doc_root", GraphQLSite::APIDocRoot)
