# frozen_string_literal: true

require "tip_tap/node"

module TipTap
  module Nodes
    class Image < Node
      self.type_name = "image"

      attr_reader :marks

      def initialize(attrs = {}, marks: [])
        super
        @attrs = attrs.deep_stringify_keys
        @marks = Array(marks).map(&:deep_stringify_keys)
      end

      def include_empty_content_in_json?
        false
      end

      def to_html
        image = image_tag(src, alt: alt)

        if marks.any? { |mark| mark["type"] == "link" }
          content_tag(:a, image, href: link_href, target: link_target, rel: link_rel, class: link_class)
        else
          image
        end
      end

      def self.from_json(json)
        json.deep_stringify_keys!
        new(
          json["attrs"] || {},
          marks: json["marks"] || []
        )
      end

      def to_h
        data = { type: type_name, attrs: attrs }
        data[:marks] = marks unless marks.empty?
        data
      end

      def to_markdown(context = Markdown::Context.root)
        return "" if src.blank?

        alt_text = alt.to_s
        escaped_alt = alt_text.gsub("[", "\\[").gsub("]", "\\]")
        escaped_src = src.to_s.gsub("(", "\\(").gsub(")", "\\)")
        "![#{escaped_alt}](#{escaped_src})"
      end

      def alt
        attrs["alt"]
      end

      def src
        attrs["src"]
      end

      def link_href
        marks.find { |mark| mark["type"] == "link" }&.dig("attrs", "href")
      end

      def link_target
        marks.find { |mark| mark["type"] == "link" }&.dig("attrs", "target")
      end

      def link_rel
        marks.find { |mark| mark["type"] == "link" }&.dig("attrs", "rel")
      end

      def link_class
        marks.find { |mark| mark["type"] == "link" }&.dig("attrs", "class")
      end
    end
  end
end
