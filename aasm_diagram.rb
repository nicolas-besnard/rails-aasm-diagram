class AasmDiagram
  attr_reader :klass, :machine_name

  def initialize(klass, machine_name)
    @klass        = klass
    @machine_name = machine_name
  end

  def run
    diagram = {}

    klass.aasm(machine_name).states.map(&:name).each do |state|
      permitted_state       = klass.new(machine_name => state).aasm(machine_name).states(permitted: true).map(&:name)
      diagram[state.to_sym] = permitted_state
    end

    diagram
  end
end
