class AasmDiagram
  attr_reader :klass, :machine_name

  def initialize(klass, machine_name = nil)
    @klass        = klass
    @machine_name = machine_name
  end

  def run
    t = {}

    klass.aasm.events.each do |event|
      event_name = event.name.to_sym

      t[event_name] = []

      event.transitions.each do |transition|
        t[event_name] << [transition.from, transition.to]
      end
    end

    t
  end

  def initial_state_name
    @initial_state_name ||= klass.aasm.states.find{|s| s.options.fetch(:initial) { next} }.name
  end

  def diagram
    t = []
    run.each do |event, transitions|
      transitions.each do |from, to|
        elem = "#{from}->#{to}:#{event}"
        if from == initial_state_name
          t.insert(0, elem)
        else
          t << elem
        end
      end
    end
    t.join("\n")
  end
end
