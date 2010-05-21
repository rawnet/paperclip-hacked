module Paperclip
  # The Upfile module is a convenience module for adding uploaded-file-type methods
  # to the +File+ class. Useful for testing.
  #   user.avatar = File.new("test/test_avatar.jpg")
  module Upfile

    # Infer the MIME-type of the file from the extension.
    def content_type
      type = (self.path.match(/\.(\w+)$/)[1] rescue mime_type_fuee).downcase
      case type
      when %r"jp(e|g|eg)"            then "image/jpeg"
      when %r"tiff?"                 then "image/tiff"
      when %r"png", "gif", "bmp"     then "image/#{type}"
      when "txt"                     then "text/plain"
      when %r"html?"                 then "text/html"
      when "js"                      then "application/js"
      when "csv", "xml", "css"       then "text/#{type}"
      else
        Paperclip.run("file", "--mime-type #{self.path}").split(':').last.strip rescue "application/x-#{type}"
      end
    end

    # Returns the file's normal name.
    def original_filename
      File.basename(self.path)
    end

    # Returns the size of the file.
    def size
      File.size(self)
    end
    
    def mime_type_fuee
      if File.respond_to?(:mime_type?)
        File.mime_type?(self)
      else
        "octet-stream"
      end
    end
  end
end

if defined? StringIO
  class StringIO
    attr_accessor :original_filename, :content_type
    def original_filename
      @original_filename ||= "stringio.txt"
    end
    def content_type
      @content_type ||= "text/plain"
    end
  end
end

class File #:nodoc:
  include Paperclip::Upfile
end

