# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class FiveCardExtension < Radiant::Extension
  version "0.1"
  description "Simple 5 card stud poker."
  url "http://codygray.ca/five_card"
  
  define_routes do |map|
#    map.namespace :admin, :member => { :remove => :get } do |admin|
#      admin.resources :five_card
#    end
#    map.resources :five_card
    map.connect 'five_card', :controller => 'five_card', :action => 'new'
  end
  
  def activate
#    admin.tabs.add "Five Card", "/admin/five_card", :after => "Layouts", :visibility => [:all]
  end
  
  def deactivate
#    admin.tabs.remove "Five Card"
  end
  
end
