##
# For views needing to display `HeroImage` objects
module HeroImageDisplayingView
  extend ActiveSupport::Concern

  protected

  def hero_config(hero_image)
    return nil unless hero_image.present?
    {
      hero_image: hero_image.file.present? ? hero_image.file.url : nil,
      attribution_title: hero_image.settings_attribution_title,
      attribution_creator: hero_image.settings_attribution_creator,
      attribution_institution: hero_image.settings_attribution_institution,
      attribution_url: hero_image.settings_attribution_url,
      attribution_text: hero_image.settings_attribution_text,
      brand_opacity: "brand-opacity#{hero_image.settings_brand_opacity}",
      brand_position: "brand-#{hero_image.settings_brand_position}",
      brand_colour: "brand-colour-#{hero_image.settings_brand_colour}"
    }.merge(hero_license(hero_image)).merge(hero_ripple_width(hero_image))
  end

  def hero_ripple_width(hero_image)
    hero_image.settings_ripple_width.blank? ? {} : { "ripple_size_#{hero_image.settings_ripple_width}" => true }
  end

  def hero_license(hero_image)
    hero_image.license.blank? ? {} : { hero_license_template_var_name(hero_image.license) => true }
  end

  def hero_license_template_var_name(license)
    'license_' + license.tr('-', '_')
  end

  def strapline
    return_hash = {}
    text = @landing_page.strapline.present? ? @landing_page.strapline(total_item_count: number_with_delimiter(@total_item_count)) : nil
    text_parts = text.split("%LINKS%")
    puts "TEXT PARTS COUNT: #{text_parts.count}"
    if text_parts.count == 2
      return_hash[:text_start] = text_parts.first
      return_hash[:strapline_entry_points] = strapline_entry_points
      return_hash[:text_end] = text_parts.last
      return_hash[:text_only] = text_parts.first + strapline_entry_points.map{ |link| link[:text] }.join(", ") + text_parts.last
    else
      return_hash[:text_start] = text
      return_hash[:text_only] = text
    end
    return_hash
  end

  def strapline_entry_points
    entry_points = @landing_page.strapline_entry_points.map{|link| {url: link.url, text: link.text, comma: true} }
    entry_points[-1].delete(:comma) if entry_points.count > 0
    if entry_points.count >= 2
      entry_points[-2].delete(:comma)
      entry_points[-2][:and] = true
    end
    return entry_points
  end

end
