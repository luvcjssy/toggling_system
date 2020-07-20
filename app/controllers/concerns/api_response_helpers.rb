module ApiResponseHelpers
  extend ActiveSupport::Concern

  def build_meta_object(object, additional_keys = nil)
    pager = {}
    if object.present?
      pager = pager.merge(
        current_page: object.current_page,
        per_page: object.per_page,
        total_count: object.total_entries,
        total_page: (object.total_entries / object.per_page.to_f).ceil
      )
    end

    pager = pager.merge(additional_keys) if additional_keys.present?

    # Important !!! Must return pager otherwise this will be null
    pager
  end

  def render_result(message, success, objects, serializer, meta_data = {})
    hash = { success: success, message: message, data: [] }
    objects.each do |object|
      serial = serializer.new(object).as_json
      hash[:data].push(serial)
    end
    hash = hash.merge!(meta_data)
    render json: hash
  end

  def render_object(message, object, serializer, instance_options = {})
    hash = { success: true, message: message, data: {} }

    if object
      json = serializer.new(object, instance_options).as_json
      hash[:data] = hash[:data].merge(json)
    end

    render json: hash
  end

  def render_data(message, data)
    render json: { success: true, message: message, data: data }
  end

  def render_sucess(message)
    hash = { success: true, message: message }
    render json: hash
  end
end
