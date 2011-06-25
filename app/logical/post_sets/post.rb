module PostSets
  class Post < Base
    attr_reader :tag_array, :page, :posts
    
    def initialize(params)
      @tag_array = Tag.scan_query(params[:tags])
      @page = params[:page]
      @posts = ::Post.tag_match(tag_string).paginate(page)
    end
    
    def tag_string
      @tag_string ||= tag_array.join(" ")
    end
    
    def has_wiki?
      tag_array.any? && ::WikiPage.titled(tag_string).exists?
    end
    
    def wiki_page
      if tag_array.any?
        ::WikiPage.titled(tag_string).first
      else
        nil
      end
    end
    
    def has_artist?
      tag_array.any? && ::Artist.name_equals(tag_string).exists?
    end
    
    def artist
      ::Artist.name_equals(tag_string).first
    end
    
    def is_single_tag?
      tag_array.size == 1
    end
    
    def presenter
      @presenter ||= ::PostSetPresenters::Post.new(self)
    end
  end
end
