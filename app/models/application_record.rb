class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  private
  
    def helper
      @helper ||= Class.new do
        include ActionView::Helpers::NumberHelper
      end.new
    end
    
end
