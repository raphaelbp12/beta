class Term < ActiveRecord::Base
  self.table_name = 'vr_terms'

  belongs_to :term_taxonomy, foreign_key: 'term_taxonomy_id'

  has_many :posts, primary_key: 'term_id'
end
