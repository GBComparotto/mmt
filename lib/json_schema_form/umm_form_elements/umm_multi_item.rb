# :nodoc:
class UmmMultiItem < UmmFormElement
  def default_value
    []
  end

  # Return whether or not this element has a stored value
  def value?
    Array.wrap(element_value).reject(&:empty?).any?
  end

  def last_key
    form_fragment.fetch('key', '').split('/').last
  end

  def form_title
    last_key.titleize.singularize
  end

  def form_class
    last_key.underscore.dasherize
  end

  def render_preview
    capture do
      values = Array.wrap(element_value)
      values = [''] if values.empty?
      values.each_with_index do |_value, index|
        concat(content_tag(:fieldset) do
          concat content_tag(:h6, "#{parsed_json['key'].titleize.singularize} #{index + 1}")

          form_fragment['items'].each do |property|
            UmmFormSection.new(form_section_json: property, json_form: json_form, schema: schema, options: { 'index' => index }).children.each do |child|
              concat child.render_preview
            end
          end
        end)
      end
    end
  end

  def render_markup
    content_tag(:div, class: "multiple simple-multiple #{form_class}") do
      values = Array.wrap(element_value)
      values = [''] if values.empty?
      values.each_with_index do |value, index|
        concat(content_tag(:div, class: "multiple-item multiple-item-#{index}") do
          form_fragment['items'].each do |property|
            concat UmmForm.new(form_section_json: property, json_form: json_form, schema: schema, options: { 'index' => index }, key: full_key, field_value: value).render_markup
            concat UmmRemoveLink.new(form_section_json: parsed_json, json_form: json_form, schema: schema, options: { 'name' => title }).render_markup
          end

          concat(content_tag(:div, class: 'actions') do
            button = UmmButton.new(form_section_json: form_fragment, json_form: json_form, schema: schema, options: { 'button_text' => "Add another #{form_title}", 'classes' => 'eui-btn--blue add-new new-simple' }).render_markup
            concat button
          end)
        end)
      end
    end
  end
end