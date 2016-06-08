module Facet
  class CollectionPresenter < SimplePresenter
    def facet_item_url(item)
      search_action_url(add_facet_params(item))
    end

    def add_facet_params(item)
      value = facet_value_for_facet_item(item)

      if value == 'all'
        params.except(:id).merge(controller: :portal, action: :index)
      else
        params.merge(controller: :collections, action: :show, id: value)
      end
    end

    def facet_in_params?(field, item)
      value = facet_value_for_facet_item(item)

      facet_params(field) == value
    end

    def facet_params(_field)
      params[:controller] == 'collections' ? params[:id] : 'all'
    end

    def ordered_items
      super.tap do |items|
        if all = items.detect { |item| facet_value_for_facet_item(item) == 'all' }
          items.unshift(items.delete(all))
        end
      end
    end
  end
end
