class PostSerializer < BaseSerializer
  attributes :id, :title, :content, :description, :taxonomys, :postmetas, :terms, :coordinates, :banner, :associados, :posts_editorial

  def title
    object.post_title
  end

  def content
    object.post_content
  end

  def description
    object.post_excerpt
  end

  def taxonomys
    object.term_taxonomys
  end

  def postmetas
    object.postmetas
  end

  def terms
    object.terms
  end

  def coordinates
    object.get_coords
  end

  def banner
    object.get_banner
  end

  def associados
    object.get_associados
  end

  def posts_editorial
    object.get_posts_editorial
  end

end
