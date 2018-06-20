# render elements that may have multiple values

# :nodoc:
class UmmPreviewMultiItems < UmmPreviewElement
  def render
    capture do
      indexes = options.fetch('indexes', [])

      values = Array.wrap(element_value)
      values = [{}] if values.empty?

      values.each_with_index do |value, index|
        concat(content_tag(:fieldset) do
          concat content_tag(:h6, "#{field_title(form_json).singularize} #{index + 1}")

          fields.each do |field|
            concat(UmmPreviewField.new(schema_type: schema_type, form_json: field, data: data, form_id: form_id, key: full_key, draft_id: draft_id, options: options.merge('indexes' => indexes + [index])).render)
          end
        end)
      end
    end
  end
end
