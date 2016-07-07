# frozen_string_literal: true

##
# Helper for working with Markdown formatted text
module MarkdownHelper
  ##
  # Convert Markdown to HTML
  #
  # @param md [String] Markdown formatted text
  # @return [String] HTML equivalent
  def markdown(md)
    markdown_parser.render(md)
  end

  def markdown_parser
    @markdown_parser ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end
end
