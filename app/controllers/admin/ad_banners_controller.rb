class Admin::AdBannersController < Admin::ResourceController
  model_class AdBanner
  
  only_allow_access_to :index, :new, :create, :edit, :update, :sort, :destroy, :delete,
    :when => [:admin, :ads],
    :denied_url => { :controller => 'pages', :action => 'index' },
    :denied_message => 'You must have administrative privileges to perform this action.'
  
end
