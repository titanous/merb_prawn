module Merb::Template
  class Prawn
    
    # Defines a method for calling a specific Prawn template.
    #
    # ==== Parameters
    # path<String>:: Path to the template file.
    # name<~to_s>:: The name of the template method.
    # locals<Array[Symbol]>:: A list of locals to assign from the args passed into the compiled template.
    # mod<Class, Module>::
    #   The class or module wherein this method should be defined.
    def self.compile_template(io, name, locals, mod)
      path = File.expand_path(io.path)
      method = mod.is_a?(Module) ? :module_eval : :instance_eval
      assigns = locals.inject([]) do |a, l|
        a << "#{l} = _locals[#{l.inspect}];"
      end.join
      mod.send(method, %{
        def #{name}(_locals={})
          extend #{DocumentProxy}
          @_engine = 'prawn'
          #{assigns}
          #{io.read}
          pdf.render
        end
        })
      name
    end
    
    module DocumentProxy
      def pdf
        @pdf ||= ::Prawn::Document.new
      end
      
      private
      
        def method_missing(method, *args, &block)
          pdf.respond_to?(method) ? pdf.send(method, *args, &block) : super
        end
    end
    
    module Mixin
    end

    Merb::Template.register_extensions(self, %w[prawn])
  end
end