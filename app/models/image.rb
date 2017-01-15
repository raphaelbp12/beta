class Image < ActiveRecord::Base
  self.table_name = "vr_posts"

  default_scope { where(post_type: 'attachment') }
end
