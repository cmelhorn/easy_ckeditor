# Ckeditor
module Ckeditor
  PLUGIN_NAME = 'easy-ckeditor'
  PLUGIN_PATH = "#{RAILS_ROOT}/vendor/plugins/#{PLUGIN_NAME}"
  PLUGIN_PUBLIC_PATH = "#{PLUGIN_PATH}/public"
  PLUGIN_CONTROLLER_PATH = "#{PLUGIN_PATH}/app/controllers"
  PLUGIN_VIEWS_PATH = "#{PLUGIN_PATH}/app/views"
  PLUGIN_HELPER_PATH = "#{PLUGIN_PATH}/app/helpers"

  module Helper
    def ckeditor_textarea(object, field, options = {})
      var = instance_variable_get("@#{object}")
      if var
        value = var.send(field.to_sym)
        value = value.nil? ? "" : value
      else
        value = ""
        klass = "#{object}".camelcase.constantize
        instance_variable_set("@#{object}", eval("#{klass}.new()"))
      end
      id = ckeditor_element_id(object, field)

      cols = options[:cols].nil? ? '' : "cols='"+options[:cols]+"'"
      rows = options[:rows].nil? ? '' : "rows='"+options[:rows]+"'"

      width = options[:width].nil? ? '100%' : options[:width]
      height = options[:height].nil? ? '100%' : options[:height]

      toolbarSet = options[:toolbarSet].nil? ? 'Default' : options[:toolbarSet]

      if options[:ajax]
        inputs = "<input type='hidden' id='#{id}_hidden' name='#{object}[#{field}]'>\n" <<
                 "<textarea id='#{id}' #{cols} #{rows} name='#{id}'>#{value}</textarea>\n"
      else
        inputs = "<textarea id='#{id}' #{cols} #{rows} name='#{object}[#{field}]'>#{value}</textarea>\n"
      end

      js_path = "#{controller.relative_url_root}/javascripts"
      base_path = "#{js_path}/ckeditor/"
      return inputs <<
        javascript_tag("var oCKeditor = new CKeditor('#{id}', '#{width}', '#{height}', '#{toolbarSet}');\n" <<
                       "oCKeditor.BasePath = \"#{base_path}\"\n" <<
                       "oCKeditor.Config['CustomConfigurationsPath'] = '#{js_path}/ckcustom.js';\n" <<
                       "oCKeditor.ReplaceTextarea();\n")
    end

    def ckeditor_form_remote_tag(options = {})
      editors = options[:editors]
      before = ""
      editors.keys.each do |e|
        editors[e].each do |f|
          before += ckeditor_before_js(e, f)
        end
      end
      options[:before] = options[:before].nil? ? before : before + options[:before]
      form_remote_tag(options)
    end

    def ckeditor_remote_form_for(object_name, *args, &proc)
      options = args.last.is_a?(Hash) ? args.pop : {}
      concat(ckeditor_form_remote_tag(options), proc.binding)
      fields_for(object_name, *(args << options), &proc)
      concat('</form>', proc.binding)
    end
    alias_method :ckeditor_form_remote_for, :ckeditor_remote_form_for

    def ckeditor_element_id(object, field)
      id = eval("@#{object}.id")
      "#{object}_#{id}_#{field}_editor"
    end

    def ckeditor_div_id(object, field)
      id = eval("@#{object}.id")
      "div-#{object}-#{id}-#{field}-editor"
    end

    def ckeditor_before_js(object, field)
      id = ckeditor_element_id(object, field)
      "var oEditor = CKeditorAPI.GetInstance('"+id+"'); document.getElementById('"+id+"_hidden').value = oEditor.GetXHTML();"
    end
  end
end

include ActionView
module ActionView::Helpers::AssetTagHelper
  alias_method :rails_javascript_include_tag, :javascript_include_tag

  #  <%= javascript_include_tag :defaults, :ckeditor %>
  def javascript_include_tag(*sources)
    main_sources, application_source = [], []
    if sources.include?(:ckeditor)
      sources.delete(:ckeditor)
      sources.push('ckeditor/ckeditor')
    end
    unless sources.empty?
      main_sources = rails_javascript_include_tag(*sources).split("\n")
      application_source = main_sources.pop if main_sources.last.include?('application.js')
    end
    [main_sources.join("\n"), application_source].join("\n")
  end
end
