class PostsSerializer < BaseSerializer
  attributes :id, :title, :postmetas

  def title
    object.post_title
  end

  def postmetas
    object.postmetas
  end

end
