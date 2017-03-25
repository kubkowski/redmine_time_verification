Redmine::Plugin.register :redmine_time_verification do
  name 'Redmine Time Verification plugin'
  author 'kubkowski'
  description 'Simple plugin extending time verification method in TimeEntry model.'
  version '0.0.1'
  url 'https://github.com/kubkowski/redmine_time_verification'
end

require_dependency 'time_entry'

module TimeVerificationTimeEntry
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
      alias_method_chain :validate_time_entry, :new_validation
    end
  end

  module InstanceMethods
    # Adds a new validation to time entry model.
    def validate_time_entry_with_new_validation
      validate_time_entry_without_new_validation
      errors.add :spent_on, "is too early" if (spent_on < Date.today - 1.day)
      errors.add :hours, "is too many" if hours && hours >= 16
    end
  end
end

TimeEntry.send(:include, TimeVerificationTimeEntry)