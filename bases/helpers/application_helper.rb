module ApplicationHelper

  def model(args = {})
    count = count_value args[:count]
    if args[:model]
      args[:model].model_name.human count: count
    else
      current_model.model_name.human count: count
    end
  end

  def editing(_model = nil)
    if _model
      title t(:editing) + " " + _model
    else
      title t(:editing) + " " + model
    end
  end

  # translate attributes name
  def attr(attr, args = {})
    count = count_value args[:count]
    _end = args[:end] ? args[:end] : ""
    if args[:model]
      args[:model].human_attribute_name(attr, count: count) + _end
    else
      current_model.human_attribute_name(attr, count: count) + _end
    end
  end

  def current_model
    current_controller_name.singularize.camelcase.constantize
  end

  def current_controller_name
    controller.controller_name
  end

  private
  def count_value(value)
    value ? value : 1
  end
end
