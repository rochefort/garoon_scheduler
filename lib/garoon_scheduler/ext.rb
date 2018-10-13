# Ignore below warning of httpclient:
# Cookie#domain returns dot-less domain name now. Use Cookie#dot_domain if you need "." at the beginning.
class WebAgent
  class Cookie < HTTP::Cookie
    def domain
      self.original_domain
    end
  end
end
