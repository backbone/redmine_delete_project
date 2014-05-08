class DeleteProjectController < ApplicationController

  # For the authorizations, applies filter and the function to define the current project (in the bottom of this file)
  before_filter :find_project, :authorize, :only => [:index, :valider]


  def index
    @dead_project = Project.find(params[:project_id])

    res= Array.new

    # The project ID
    project_id= @dead_project["id"]

    # Check if there are sub-projects
    # (which have not been already marked as deleted - thanks to Luis Serrano Aranda for the feedback)
    status_number= Setting['plugin_redmine_delete_project']['status_number'].to_i
    res= Project.find_by_sql("SELECT * FROM projects WHERE ( parent_id=#{project_id} AND status!=#{status_number} )")
    @subprojects= res.length

    # String to type for confirmation
    @ok= I18n.t("global.confirm_string")
  end


  def submit
    ok= I18n.t("global.confirm_string")
    # Get the settings
    status_number= Setting['plugin_redmine_delete_project']['status_number'].to_i
    chmod= Setting['plugin_redmine_delete_project']['chmod']
    destroy= Setting['plugin_redmine_delete_project']['destroy']
    repos_path= Setting['plugin_redmine_delete_project']['repos_path'] + "/"

    if params[:confirm][0] == ok
      dead_project= Project.find_by_identifier(params[:dead_project])
      if destroy == "yes"
        res= dead_project.destroy
      else
        dead_project.status= status_number
        res= dead_project.save
      end

      if res
        flash[:notice]= I18n.t("project_delete.done")
        if chmod == "yes"
          File.chmod 0000, repos_path + dead_project.identifier
        end
      else
        flash[:error]= I18n.t("project_delete.error")
      end

    else
      flash[:notice]= I18n.t("project_delete.unconfirmed", :ok => ok)
    end
  end


  private
  def find_project
    # @project variable must be set before calling the authorize filter
    @project = Project.find(params[:project_id])
  end

end




