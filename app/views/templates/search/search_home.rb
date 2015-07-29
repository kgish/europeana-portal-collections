module Templates
  module Search
    class SearchHome < ApplicationView
      def navigation
        {
          global: navigation_global,
          footer: common_footer
        }
      end

      def content
        {
          hero_config: config[:content][:hero_config],
          strapline: t('site.home.strapline', total_item_count: total_item_count),
          promoted: config[:content][:promoted],
          news: blog_news_items.blank? ? nil : {
            items: blog_news_items,
            blogurl: 'http://blog.europeana.eu/'
          }
        }
      end

      private

      def config
        Rails.application.config.channels[:home]
      end

      def blog_news_items
        @blog_news_items ||= news_items(@blog_items)
      end
    end
  end
end
