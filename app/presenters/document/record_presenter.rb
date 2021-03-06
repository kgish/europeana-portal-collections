module Document
  ##
  # Blacklight document presenter for a Europeana record
  class RecordPresenter < DocumentPresenter
    include Record::IIIF
    include Metadata::Rights

    def edm_is_shown_by
      @edm_is_shown_by ||= field_value('aggregations.edmIsShownBy')
    end

    def edm_object
      @edm_object ||= aggregation.fetch('edmObject', nil)
    end

    def aggregation
      @first_aggregation ||= @document.aggregations.first
    end

    def is_shown_by_or_at
      aggregation.fetch('edmIsShownBy', nil) || aggregation.fetch('edmIsShownAt', nil)
    end

    def has_views
      @has_views ||= aggregation.fetch('hasView', []).compact
    end

    def edm_is_shown_by_web_resource
      @edm_is_shown_by_web_resource ||= begin
        web_resources.detect do |web_resource|
          web_resource.fetch('about', nil) == edm_is_shown_by
        end
      end
    end

    def web_resources
      @web_resources ||= begin
        aggregation.respond_to?(:webResources) ? aggregation.webResources : []
      end
    end

    def edm_object_thumbnails_edm_is_shown_by?
      edm_is_shown_by.present? && edm_object.present? && (edm_object != edm_is_shown_by)
    end

    def edm_object_thumbnails_has_view?
      edm_object.present? && has_views.include?(edm_object)
    end

    def media_web_resource_presenters
      return [] if web_resources.blank?

      @media_web_resource_presenters ||= begin
        salient_web_resources = web_resources.dup.tap do |web_resources|
          # make sure the edm_is_shown_by is the first item
          unless edm_is_shown_by_web_resource.nil?
            web_resources.unshift(web_resources.delete(edm_is_shown_by_web_resource))
          end
        end
        presenters = salient_web_resources.map do |web_resource|
          Document::WebResourcePresenter.new(web_resource, @controller, @configuration, @document, self)
        end
        presenters.uniq(&:url)
      end
    end

    def displayable_media_web_resource_presenters
      media_web_resource_presenters.select(&:displayable?)
    end

    def media_web_resources(options = {})
      Kaminari.paginate_array(displayable_media_web_resource_presenters).
        page(options[:page]).per(options[:per_page])
    end

    def media_rights
      @media_rights ||= field_value('aggregations.edmRights')
    end

    def field_group(id)
      @field_group_presenter ||= Document::FieldGroupPresenter.new(document, controller)
      @field_group_presenter.display(id)
    end
  end
end
