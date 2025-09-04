# frozen_string_literal: true

require "tip_tap/node"

module TipTap
  module Nodes
    class TableHeader < Node
      self.type_name = "tableHeader"
      self.html_tag = :th

      def paragraph(&block)
        raise ArgumentError, "Block required" if block.nil?

        add_content(Paragraph.new(&block))
      end

      def html_attributes
        super.merge(cell_attributes).compact_blank
      end

      def cell_attributes
        {
          colspan: attrs["colspan"],
          rowspan: attrs["rowspan"],
        }
      end
    end
  end
end
