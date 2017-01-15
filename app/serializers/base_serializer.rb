class BaseSerializer < ActiveModel::Serializer

  def request_for_feed?
    scope[:data] == :feed
  end

end
