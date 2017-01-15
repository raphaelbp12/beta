require 'php_serialize'

class Post < ActiveRecord::Base
  self.table_name = 'vr_posts'

  has_many :postmeta, class_name: 'Postmeta', foreign_key: 'post_id'

  has_many :term_relationships, foreign_key: 'object_id'
  has_many :term_taxonomys, through: :term_relationships
  has_many :terms, through: :term_taxonomys

  scope :que_fazer, -> {where(post_type: 'que_fazer')}

  scope :published, -> {where(post_status: 'publish')}

  def self.search_neighborhoods(search, offset)
    Rails.cache.fetch("search_neighborhoods_query_#{search}_#{offset}", expires_in: 1.day) do
      Post.eager_load(:term_taxonomys)
      .where(post_status: 'publish')
      .joins(:postmeta)
      .where("vr_postmeta.meta_key = 'infos_0_bairro' AND vr_postmeta.meta_value = ?", search)
      .where("post_parent = 0")
      .order("post_title ASC")
      .limit(10).offset(offset).to_a
    end
  end

  def self.search(search, offset)
    Rails.cache.fetch("search_query_#{search}_#{offset}", expires_in: 1.day) do
      Post.eager_load(:term_taxonomys)
      .where(post_status: 'publish')
      .where("post_title LIKE '%#{search}%'")
      .where("post_parent = 0")
      .order("post_title ASC")
      .limit(10).offset(offset).to_a
    end
  end

  def self.post(id)
    Rails.cache.fetch("post_query_#{id}", expires_in: 1.day) do
      Post.eager_load(:term_taxonomys).eager_load(:terms).eager_load(:postmeta).where('ID = ?', id).published.to_a
    end
  end

  def self.events(offset)
    Rails.cache.fetch("events_#{offset}_#{Time.now.strftime("%Y%m%d")}") do
      Post.eager_load(:term_taxonomys)
      .eager_load(:terms)
      .joins(:postmeta)
      .where(post_type: 'evento')
      .where(post_status: 'publish')
      .where("vr_postmeta.meta_key = 'data_final' AND vr_postmeta.meta_value >= ?", Time.now.strftime("%Y%m%d"))
      .order("CASE WHEN vr_postmeta.meta_key = 'data_final' THEN vr_postmeta.meta_value END asc")
      .limit(10).offset(offset).to_a
    end
  end

  def self.get_posts_by_term_and_taxonomy(taxonomy, term, offset)
    Rails.cache.fetch("posts_#{taxonomy}_#{term}_#{offset}") do
      Post.eager_load(:term_taxonomys)
      .eager_load(:terms)
      .eager_load(:postmeta)
      .where('vr_term_taxonomy.taxonomy = ?', taxonomy)
      .where('vr_terms.slug=?', term)
      .published
      .order("post_title ASC")
      .limit(10)
      .offset(offset).to_a
    end
  end

  def get_associados
    postmetas = (Rails.cache.fetch("_postmetas_#{self.ID.to_s}") do
                    self.postmeta.to_a
                  end)
    ids = []
    posts = []
    postmetas.each do |postmeta|
      if postmeta.meta_key == 'associados' && postmeta.meta_value != ""
        ids = PHP.unserialize(postmeta.meta_value)
      end
    end

    ids.each do |id|
      posts.push(Post.post(id)[0])
    end

    ActiveModel::ArraySerializer.new(posts, each_serializer: EventsSerializer)
  end

  def get_posts_editorial
    postmetas = (Rails.cache.fetch("_postmetas_#{self.ID.to_s}") do
                    self.postmeta.to_a
                  end)
    ids = []
    posts = []
    postmetas.each do |postmeta|
      if postmeta.meta_key == 'posts_editorial' && postmeta.meta_value != ""
        ids = PHP.unserialize(postmeta.meta_value)
      end
    end

    ids.each do |id|
      posts.push(Post.post(id)[0])
    end

    ActiveModel::ArraySerializer.new(posts, each_serializer: EventsSerializer)
  end

  def get_gallery
    postmetas = (Rails.cache.fetch("_postmetas_#{self.ID.to_s}") do
                    self.postmeta.to_a
                  end)
    links = []
    ids = []
    postmetas.each do |postmeta|
      if postmeta.meta_key == 'galeria' && postmeta.meta_value != ""
        ids = PHP.unserialize(postmeta.meta_value)
      end
    end

    ids.each do |id|
      links.push(treat_guid_url(Post.find(id).guid,500))
    end

    links
  end

  def get_slider()
    postmetas = (Rails.cache.fetch("_postmetas_#{self.ID.to_s}") do
                    self.postmeta.to_a
                  end)
    ids = []
    posts = []

    postmetas.each do |postmeta|
      if postmeta.meta_key === "banner" && postmeta.meta_value != ""
        ids = PHP.unserialize(postmeta.meta_value)
      end
    end

    ids.each do |id|
      posts.push(Post.post(id)[0])
    end

    posts
  end

  def self.get_slider_trans(lang)
    p "get_slider_trans"
    ids = []
    posts = Post.find(243).get_slider()

    posts.each do |post|
      post.term_taxonomys.each do |taxonomyi|
        if taxonomyi.taxonomy === "post_translations"
          id = PHP.unserialize(taxonomyi.description)[lang]
          if !id.nil?
            ids.push(id)
          end
        end
      end
    end

    Post.find(ids)
  end


  def get_banner
    postmetas = (Rails.cache.fetch("_postmetas_#{self.ID.to_s}") do
                    self.postmeta.to_a
                  end)
    link = ''

    postmetas.each do |postmeta|
      if postmeta.meta_key === "imagem_banner" && postmeta.meta_value != ""
        p postmeta.meta_value
        if postmeta.meta_value.include? ","
          imageid = JSON.parse(postmeta.meta_value).to_a[0][1]
        else
          imageid = postmeta.meta_value
        end
        if !Post.where(ID: imageid)[0].nil?
          link = (Rails.cache.fetch("imagem_banner#{imageid}_250") do
                          treat_guid_url(Post.find(imageid).guid, 250)
                        end)
        end
      end
    end

    link
  end

  def get_coords
    postmetas = (Rails.cache.fetch("_postmetas_#{self.ID.to_s}") do
                    self.postmeta.to_a
                  end)
    address = ''
    postmetas.each do |postmeta|
      if postmeta.meta_key == 'infos_evento_0_logradouro'
        address += postmeta.meta_value
      elsif postmeta.meta_key == 'infos_evento_0_numero'
        address += ', ' + postmeta.meta_value
      elsif postmeta.meta_key == 'infos_evento_0_bairro'
        address += ', ' + postmeta.meta_value
      elsif postmeta.meta_key == 'infos_0_logradouro'
        address += postmeta.meta_value
      elsif postmeta.meta_key == 'infos_0_numero'
        address += ', ' + postmeta.meta_value
      elsif postmeta.meta_key == 'infos_0_bairro'
        address += ', ' + postmeta.meta_value
      end
    end
    address = address + ', Rio de Janeiro'

    coords = Geocoder.coordinates(address)

    if !coords.nil?
      if !coords.empty?
        {lat: coords[0], long: coords[1]}
      else
        false
      end
    else
      false
    end

  end

  def treat_guid_url(url_input, pixels)
    url = ''
    if url_input.include?("http://visitriocache.s3.amazonaws.com/")
      if url_input.include?("/023-visit-rio")
        url = url_input.split('/023-visit-rio')[0]+url_input.split('/023-visit-rio')[1]


      else
        url = url_input
      end
    else
      url = "http://visitriocache.s3.amazonaws.com/#{url_input.split('http://visit.rio/')[1]}"
    end

    extlen = url.split(".")[-1].length
    url[0..((extlen+2) * -1)]+"-500x250"+url[((extlen+1) * -1)..-1]
  end

  def gallery

     images =Image.all.to_a

     post_images = images.select{|a|a.post_parent == self.ID}
     if !post_images.empty?
       post_images.map do |post_image|
         if post_image.guid.include?("http://rioguiaoficial.s3.amazonaws.com/")
           if post_image.guid.include?("/023-visit-rio")
             url = post_image.guid.split('/023-visit-rio')[0]+post_image.guid.split('/023-visit-rio')[1]
             url

           else
             post_image.guid
           end
         else
           url = "http://rioguiaoficial.s3.amazonaws.com/#{post_image.guid.split('http://visit.rio/')[1]}"
           url

         end
       end
     else
       false
     end
  end

  def postmetas
      p "load em postmeta "+self.ID.to_s
      postmetas = (Rails.cache.fetch("_postmetas_#{self.ID.to_s}") do
                      self.postmeta.to_a
                    end)

      postmetas = postmetas.select{|postmeta|(postmeta.meta_key == "_thumbnail_id" || (postmeta.meta_key[0] != "_" && postmeta.meta_value != ""))}.map do |postmeta|
        #p postmeta.meta_key
        if postmeta.meta_key === "_thumbnail_id" && postmeta.meta_value != ""
          meta_value = (Rails.cache.fetch("_thumbnail_id_#{postmeta.meta_value}_250") do
            if !Post.where(ID: postmeta.meta_value)[0].nil?
              treat_guid_url(Post.find(postmeta.meta_value).guid, 250)
            else
              meta_value = ""
            end
          end)

          # meta_value["cropped_image"]["image"] = "http://rioguiaoficial.s3.amazonaws.com/wp-content/uploads/#{meta_value["cropped_image"]["image"]}" if meta_value["cropped_image"]["image"]
          # meta_value["cropped_image"]["preview"] = "http://rioguiaoficial.s3.amazonaws.com/wp-content/uploads/#{meta_value["cropped_image"]["preview"]}" if meta_value["cropped_image"]["preview"]

        #elsif (postmeta.meta_key === "data_inicio") || (postmeta.meta_key === "data_final")
          #eventdate = postmeta.meta_value
          #meta_value = Date.new(eventdate[0..3].to_i, eventdate[4..5].to_i, eventdate[6..7].to_i).to_time.to_i
        elsif postmeta.meta_key === "imagem_banner" && postmeta.meta_value != ""
          if postmeta.meta_value.kind_of?(String)
            p postmeta.meta_value
            if postmeta.meta_value.include? ","
              imageid = JSON.parse(postmeta.meta_value).to_a[0][1]
            else
              imageid = postmeta.meta_value
            end
          else
            imageid = postmeta.meta_value
          end

          if !Post.where(ID: imageid)[0].nil?
            meta_value = (Rails.cache.fetch("imagem_banner#{imageid}_250") do
                            treat_guid_url(Post.find(imageid).guid, 250)
                          end)
          else
            meta_value = ""
          end
        else
          meta_value = postmeta.meta_value
        end
        {
          postmeta.meta_key => meta_value
        }
      end
      postmetas.reduce Hash.new, :merge
  end
end
