require_relative 'mixins/ead_location_generator.rb'

Resource.class_eval { include EADLocationGenerator }
