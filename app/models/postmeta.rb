class Postmeta < ActiveRecord::Base
  self.table_name = 'vr_postmeta'
  self.primary_key = 'meta_id'

  alias_attribute :value, :meta_value

  belongs_to :post, foreign_key: 'post_id'
end
