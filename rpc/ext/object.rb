# frozen_string_literal: true

class Object
  def instance_values
    ivs = instance_variables.map do |name|
      [name[1..-1], instance_variable_get(name)]
    end
    Hash[ivs]
  end

  def as_json; end
end
