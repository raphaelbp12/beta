class EventsSerializer < BaseSerializer
  attributes :id, :title, :taxonomys, :postmetas

  def title
    object.post_title
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

end
