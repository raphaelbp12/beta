module Api
  module V1
    class PostsController < BaseController

      def info_terms
        terms = TermTaxonomy.get_terms_info()

        render json: {
            meta: {
              success: true,
              locale: I18n.locale
            },
            total: terms.count,
            terms: terms
          },
          status: 200
      end

      def search
        offset = params['offset'] || 0
        search = params['search'] || ""
        search = I18n.transliterate(search)

        posts = Post.search(search, offset)

        render json: {
            meta: {
              success: true,
              locale: I18n.locale
            },
            string: search,
            total: posts.count,
            posts: ActiveModel::ArraySerializer.new(posts, each_serializer: EventsSerializer)
          },
          status: 200
      end

      def search_neighborhoods
        offset = params['offset'] || 0
        search = params['search'] || ""
        search = I18n.transliterate(search)

        posts = Post.search_neighborhoods(search, offset)

        render json: {
            meta: {
              success: true,
              locale: I18n.locale
            },
            string: search,
            total: posts.count,
            posts: ActiveModel::ArraySerializer.new(posts, each_serializer: EventsSerializer)
          },
          status: 200
      end

      def slider
        lang = params['lang'] || 'pt'
        extras = ''
        postid = 243

        if lang == 'pt'
          posts = Post.get_slider_trans('pt')

          extras = [
            {
              :title => 'Boulevard Olímpico',
              :image => 'http://visit.rio/wp-content/themes/rio/assets/img/bannerboulevard.png',
              :link => 'http://www.boulevard-olimpico.com/'
            }
          ]

        elsif lang == 'es'
          posts = Post.get_slider_trans('es')

          extras = [
            {
              :title => 'Boulevard Olímpico',
              :image => 'http://visit.rio/wp-content/themes/rio/assets/img/bannerboulevard.png',
              :link => 'http://www.boulevard-olimpico.com/'
            }
          ]

        else
          posts = Post.get_slider_trans('en')

          extras = [
            {
              :title => 'Boulevard Olímpico',
              :image => 'http://visit.rio/wp-content/themes/rio/assets/img/bannerboulevard.png',
              :link => 'http://www.boulevard-olimpico.com/?lang=en'
            }
          ]
        end

        render json: {
            meta: {
              success: true,
              locale: I18n.locale
            },
            extras: extras,
            total: posts.count,
            posts: ActiveModel::ArraySerializer.new(posts.reverse, each_serializer: EventsSerializer)
          },
          status: 200
      end

      def post
        id = params['id'] || 0

        posts = Post.post(id)

        render json: {
            meta: {
              success: true,
              locale: I18n.locale
            },
            total: posts.count,
            posts: ActiveModel::ArraySerializer.new(posts, each_serializer: PostSerializer)
          },
          status: 200
      end

      def events
        offset = params['offset'] || 0

        posts = Post.events(offset)

        render json: {
            meta: {
              success: true,
              locale: I18n.locale
            },
            total: posts.count,
            posts: ActiveModel::ArraySerializer.new(posts, each_serializer: EventsSerializer)
          },
          status: 200

      end

      def sobre

        lang = params['lang'] || 'pt'
        posts = 0

        if lang == 'pt'
          posts = Post.find([1723, 1887])
        elsif lang == 'es'
          posts = Post.find([1723, 1887])
        else
          posts = Post.find([7525, 5668])
        end

        render json: {
            meta: {
              success: true,
              locale: I18n.locale
            },
            total: posts.count,
            posts: ActiveModel::ArraySerializer.new(posts, each_serializer: EventsSerializer)
          },
          status: 200

      end

      def index
        offset = params['offset'] || 0
        taxonomy = params['taxonomy'] || ''
        term     = params['term'] || ''
        posts = Post.get_posts_by_term_and_taxonomy(taxonomy, term, offset)

        render json: {
            meta: {
              success: true,
              locale: I18n.locale
            },
            total: posts.count,
            posts: ActiveModel::ArraySerializer.new(posts, each_serializer: PostsSerializer)
          },
          status: 200

      end
    end
  end
end
