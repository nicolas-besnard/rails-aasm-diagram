class AasmDiagram
  attr_reader :klass, :machine_name

  def initialize(klass, machine_name)
    @klass        = klass
    @machine_name = machine_name
  end

  def run
    diagram = {}

    klass.aasm(machine_name).states.map(&:name).each do |state|
      puts state
      diagram[state.to_sym] ||= []

      # permitted_state = klass.new(machine_name => state).aasm(machine_name).states(permitted: true).map(&:name)

      klass.new(machine_name => state).aasm(machine_name).events.each do |event|
        event_name = event.name.to_sym

        event.transitions.each do |transition|
          diagram[state.to_sym] << [event_name, transition.to]
        end
      end
    end

    diagram
  end

  def diagram
    t = []
    run.each do |state, transitions|
      transitions.each do |event, new_state|
        t << "#{state}->#{new_state}:#{event}"
      end
    end
    t.join("\n")
  end
end
