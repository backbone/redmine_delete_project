RedmineApp::Application.routes.draw do
  #map.connect 'projects/:id/code_review/:action', :controller => 'code_review'
  match 'projects/:id/delete_project/:action', :controller => 'delete_project', :via => [:get, :post]
end
