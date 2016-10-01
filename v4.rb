class AasmDiagram
  attr_reader :klass, :machine_name

  def initialize(klass, machine_name = nil)
    @klass        = klass
    @machine_name = machine_name
  end

  def run
    diagram = {}

    # klass.aasm.events.map(&:name).each do |state|
    #   puts state
    #   diagram[state.to_sym] ||= []
    #
    #   # permitted_state = klass.new(machine_name => state).aasm.states(permitted: true).map(&:name)
    #
    #   klass.new(machine_name => state).aasm.events.each do |event|
    #     event_name = event.name.to_sym
    #
    #     event.transitions.each do |transition|
    #       diagram[state.to_sym] << [event_name, transition.to]
    #     end
    #   end
    # end


    klass.aasm.events.each do |event|
      diagram[event.name.to_sym] = []
      event.transitions.each do |transition|
        diagram[event.name.to_sym] << [transition.from, transition.to]
      end
    end

    diagram
  end

  def aasm_machine
    if machine_name
      public_send(:aasm, machine_name)
    else
      public_send(:aasm)
    end
  end

  def diagram
    t = []
    run.keys.sort_by { |a| initial_state_name }.each do |event, transitions|
      transitions.each do |from, to|
        t << "#{from}->#{to}:#{event}"
      end
    end
    t.join("\n")
  end
end
