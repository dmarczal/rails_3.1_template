BASE_URI = "~/projects/apps/rails_3.1_template/bases/"
rvm_rb = %x{rvm list}.match(/^=>\s+(.*)\s\[/)[1].strip

def get(file, from="", des="")
  copy_file "#{BASE_URI}/#{from}/#{file}", "#{des+"/" unless des.empty?}#{file}", {:force => true}
end

# create rvmrc file
run "rvm gemset create #{app_name}"
run "rvm #{rvm_rb}@#{app_name} " #gem install bundler --no-ri --no-rdoc"
run "rvm #{rvm_rb}@#{app_name} " #-S bundle install"
create_file ".rvmrc", "rvm use #{rvm_rb}@#{app_name}"

run "rm -rf test"
remove_file "app/views/layouts/application.html.erb"

get "Gemfile"
get "Guardfile"

inside "app" do
  get "application.html.haml",   "layout", "views/layouts"
  get "nifty-application.sass",  "layout", "assets/stylesheets"
  get "simple_form.css",  "layout", "assets/stylesheets"
end

inside "config/locales" do
  get "pt-BR.yml", "locales"
  get "en-US.yml", "locales"
  get "simple_form.en-US.yml", "locales"
  get "simple_form.pt-BR.yml", "locales"
end

run "mkdir -p lib/templates/haml/scaffold"

inside "lib/templates/haml/scaffold" do
  get "index.html.haml", "templates/haml/scaffold"
  get "edit.html.haml", "templates/haml/scaffold"
  get "show.html.haml", "templates/haml/scaffold"
  get "new.html.haml", "templates/haml/scaffold"
  get "_form.html.haml", "templates/haml/scaffold"
end

inside "app/helpers" do
  get "application_helper.rb", "helpers"
  get "layout_helper.rb", "helpers"
  get "error_messages_helper.rb", "helpers"
end

inside "config" do
  get "simple_form.rb", "config/initializers", "initializers"
end

run "mkdir spec"
inside "spec" do
  get "spec_helper.rb", "spec"
  get "mailer_macros.rb", "spec", "support"
end

file ".rspec" do
  <<-RSPEC
    --color
  RSPEC
end

application <<-LOCALE
    config.i18n.default_locale = "pt-BR"
LOCALE

application  <<-GENERATORS
    config.generators do |g|
      g.template_engine :haml
      g.stylesheets false
      g.test_framework  :rspec,  :views => false
      g.integration_tool :rspec, :views => true
      g.fixture_replacement :factory_girl, :dir => "spec/support/factories"
    end
GENERATORS
