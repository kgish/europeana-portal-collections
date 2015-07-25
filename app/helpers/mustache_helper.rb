module MustacheHelper
  def head_meta
    [
      #{'name':'X-UA-Compatible',    content: 'IE=edge' },
      #{'name':'viewport',           content: 'width=device-width,initial-scale=1.0' },
      { meta_name: 'HandheldFriendly',   content: 'True' },
      { httpequiv: 'Content-Type',       content: 'text/html; charset=utf-8' },
      { meta_name: 'csrf-param',         content: 'authenticity_token' },
      { meta_name: 'csrf-token',         content: form_authenticity_token }
    ]
  end

  def page_title
    if @response.nil?
      @channel ? t('site.channels.' + @channel.id.to_s + '.title') : 'Europeana Channels'
    elsif @response['action'].to_s == 'search.json'
      'Europeana Search' + search_page_title
    elsif params[:action].to_s == 'show'
      if @document.is_a?(Blacklight::Document)
        rec = @document.fetch(:title, ['']).join(', ')
        'Europeana Record' + (rec.present? ? ': ' + rec : rec)
      end
    end
  end

  def form_search
    {
      action: search_action_path(only_path: true)
    }
  end

  def head_links
    [
      # { rel: 'shortcut icon', type: 'image/x-icon', href: asset_path('favicon.ico') },
      { rel: 'stylesheet', href: styleguide_path('/css/search/screen.css'), media: 'all' }
    ]
  end

  # model for the search form
  def input_search
    {
      title: t('global.search-area.search-button-image-alt'),
      input_name: params[:q].blank? ? 'q' : 'qf[]',
      has_original: !params[:q].blank?,
      input_original: {
        value:  params[:q].blank? ? nil : params[:q],
        remove: search_action_url(remove_q_param(params))
      },
      input_values: input_search_values(*search_param_keys),
      placeholder: t('site.search.placeholder.text')
    }
  end

  def image_root
    styleguide_path('/images/')
  end

  def version
    { is_alpha: true }
  end

  def js_variables
    "var js_path='" + styleguide_path('/js/dist/') + "';"
  end

  def js_files
    js_entry_point = ENV['JS_ENTRYPOINT'] || '/js/dist/'
    js_entry_point = js_entry_point.dup << '/' unless js_entry_point.end_with?('/')

    log = Logger.new(STDOUT)
    log.level = Logger::WARN
    log.warn("js_entry_point = " + js_entry_point)


    [{ path: styleguide_path(js_entry_point + 'require.js'),
       data_main: styleguide_path(js_entry_point + 'main/main') }]
  end

  def menus
    {
      actions: {
        button_title: 'Actions',
        menu_id: 'dropdown-result-actions',
        menu_title: 'Save to:',
        items: [
          {
            url: 'http://europeana.eu',
            text: 'First Item'
          },
          {
            url: 'http://europeana.eu',
            text: 'Another Label'
          },
          {
            url: 'http://europeana.eu',
            text: 'Label here'
          },
          {
            url: 'http://europeana.eu',
            text: 'Fourth Item'
          },
          {
            divider: true
          },
          {
            url: 'http://europeana.eu',
            text: 'Another Label',
            calltoaction: true
          },
          {
            divider: true
          },
          {
            url: 'http://europeana.eu',
            text: 'Another Label',
            calltoaction: true
          }
        ]
      },
      sort: {
        button_title: 'Relevance',
        menu_id: 'dropdown-result-sort',
        menu_title: 'Sort by:',
        items: [
          {
            text: 'Date',
            url: 'http://europeana.eu'
          },
          {
            text: 'Alphabetical',
            url: 'http://europeana.eu'
          },
          {
            text: 'Relevance',
            url: 'http://europeana.eu'
          },
          {
            divider: true
          },
          {
            url: 'http://europeana.eu',
            text: 'Another Label',
            calltoaction: true
          },
          {
            divider: true
          },
          {
            text: 'Advanced Search',
            url: 'http://europeana.eu',
            calltoaction: true
          }
        ]
      }
    }
  end

  def total_item_count
    @europeana_item_count ? number_with_delimiter(@europeana_item_count) : nil
  end

  def channels_nav_links
    available_channels.collect do |c|
      {
        url: channel_path(c),
        text: c
      }
    end
  end

  def page_config
    {
      :newsletter  => true
    }
  end

  def search_page_title
    return '' if params[:q].nil?

    ': ' + [params[:q]].flatten.join(', ')
  end


  def navigation_global
  {
      :options => {
        :search_active  => false,
        :settings_active  => true
      },

      :logo  => {
        :url  => "/",
        :text  => "Europeana Search"
      },

      :primary_nav  => {
        :items  => [
          {
            :url  => "#",
            :text  => "Home",
            :is_current  => true
          },
          {
            :url  => "",
            :text  => "Channels",
            :submenu  => {
              :items  => [
                {
                  :url  => "http://google.com",
                  :text  => "Channel 1"
                },
                {
                  :url  => "http://google.com",
                  :text  => "Channel 2",
                  :is_current  => true
                },
                {
                  :url  => "http://google.com",
                  :text  => "Channel 3"
                }
              ]
            }
          },
          {
            :url   =>  "",
            :text  =>  "Exhibitions"
          },
          {
            :url   => "",
            :text  => "Blog"
          },
          {
            :url   => "",
            :text  => "My Europeana"
          }
        ]
    }
  }
  end

  def common_footer
    {
      :linklist1  => {
        :title  => "More info",
        :items  =>  [
          {
            :text  => "New collections",
            :url   => "http://google.com"
          },
          {
            :text => "All data providers",
            :url  => "http://google.com"
          },
          {
            :text =>  "Become a data provider",
            :url  => "http://google.com"
          }
        ]
      },
      :linklist2 => {
        :title  =>  "Help",
        :items  =>  [
          {
            :text => "Search tips",
            :url  => "http://google.com"
          },
          {
            :text =>  "Using My Europeana",
            :url  => "http://google.com"
          },
          {
            :text  => "Copyright",
            :url   => "http://google.com"
          }
        ]
      },
      :social  => {
        :facebook   => true,
        :pinterest  => true,
        :twitter    => true,
        :googleplus => true
      }
    }
  end

  def styleguide_path(asset = nil)
    ENV['EUROPEANA_STYLEGUIDE_CDN'] + (asset.present? ? asset : '')
  end

  private

  # @param keys [Symbol] keys of params to gather template input field data for
  # @return [Array<Hash>]
  def input_search_values(*keys)
    return [] if keys.blank?
    keys.map do |k|
      [params[k]].flatten.compact.map do |v|
        {
          name: params[k].is_a?(Array) ? "#{k}[]" : k.to_s,
          value: input_search_param_value(k, v),
          remove: search_action_url(remove_search_param(k, v, params))
        }
      end
    end.flatten.compact
  end

  ##
  # Returns text to display on-screen for an active search param
  #
  # @param key [Symbol] parameter key
  # @param value value of the parameter
  # @return [String] text to display
  def input_search_param_value(key, value)
    case key
    when :mlt
      response, doc = controller.fetch(value)
      item = render_index_field_value(doc, ['dcTitleLangAware', 'title'])
      t('site.search.similar.prefix', mlt_item: item)
    else
      value.to_s
    end
  end

  ##
  # Keys of parameters to preserve across searches as hidden input fields
  #
  # @return [Array<Symbol>]
  def search_param_keys
    [:qf, :mlt]
  end

  def news_items(items)
    items[0..2].map do |item|
      {
        image_root: nil,
        headline: {
          medium: CGI.unescapeHTML(item.title)
        },
        url: CGI.unescapeHTML(item.url),
        img: {
          rectangle: {
            src: news_item_img_src(item),
            alt: nil
          }
        },
        excerpt: {
          short: CGI.unescapeHTML(item.summary)
        }
      }
    end
  end

  def news_item_img_src(item)
    return nil unless item.content.present?
    img_tag = item.content.match(/<img [^>]*>/i)[0]
    return nil unless img_tag.present?
    url = img_tag.match(/src="([^"]*)"/i)[1]
    mo = MediaObject.find_by_source_url_hash(MediaObject.hash_source_url(url))
    mo.nil? ? nil : mo.file.url(:medium)
  end
end
