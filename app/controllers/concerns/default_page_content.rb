module DefaultPageContent
  extend ActiveSupport::Concern

  included do 
  before_action :set_page_defaults
  end

  def set_page_defaults
    @page_title = "Tatjana Tanaskovic | Portfolio Website"
    @seo_keywords = "Tatjana Tanaskovic Portfolio"
  end
end
