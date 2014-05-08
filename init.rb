require 'redmine'

Redmine::Plugin.register :redmine_delete_project do
  name 'Redmine Delete Project plugin'
  author 'Anthony Paul'
  description 'Adds an ACL to allow project deletion by non-admin users'
  version '0.0.4'

  project_module :delete_project do
  permission :delete_project, {:delete_project => [:index, :submit]}
  end
  menu :project_menu, :delete_project, { :controller => 'delete_project', :action => 'index' },
                      :caption => :label_feature_name,
                      :after => :activity,
                      :param => :project_id


# Configure options
settings_defaults = {
  'destroy' => "no",
  'chmod' => "no",
  'repos_path' => "/var/svn",
  'status_number' => "1001"
}
settings :default => settings_defaults, :partial => 'settings/delete_project'

end

