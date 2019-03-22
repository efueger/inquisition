require 'rails'
require 'execjs'

module Inquisition
  module Core
    module Presenters
      module Pages
        class IndexPagePresenter < PagePresenter
          GIT_FOLDER = '.git'.freeze

          attr_reader :database_presenter, :rails_about_presenter
          def_delegators :@rails_about_presenter, :database_adapter

          def initialize(auditors_tree)
            @auditors_tree = auditors_tree
            @database_presenter = DatabaseLintersPresenter.new(auditors_tree)
            @rails_about_presenter = RailsAboutPresenter.new
            super
          end

          def ruby_version
            RUBY_VERSION
          end

          def rails_version
            Rails::VERSION::STRING
          end

          def quantity_of_gems
            File.foreach(File.join(Dir.pwd, 'Gemfile')).grep(/gem /).count
          end

          def git_existence?
            File.exist?(File.join(Dir.pwd, GIT_FOLDER))
          end

          def js_runtime_version
            ExecJS.runtime.name
          end

          def files_summary_table
            FilesSummaryPresenter.new.call
          end

          def included_linters
            BaseConfig.included_linters.map(&:keys).flatten
          end

          def disabled_linters
            BaseConfig.disabled_linters.map(&:keys).flatten
          end

          def list_with_routes
            RoutesPresenter.new.call
          end

          def errors_count_chart
            ErrorsCountPresenter.new(@auditors_tree).call
          end

          def issues_pipeline
            IssuesPipelinePresenter.new(@auditors_tree).call
          end

          def hottest_issues
            HottestIssuesPresenter.new(@auditors_tree).call
          end
        end
      end
    end
  end
end
