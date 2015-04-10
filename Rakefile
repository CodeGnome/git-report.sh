require 'rake'

desc 'update ctags'
task :ctags do
  sh "ctags -R"
end

desc 'run bats unit tests'
task :test do
  test_files = FileList['test/*bats']
  if ENV["TEST"]
    sh "bats #{ENV["TEST"]}"
  else
    sh "bats #{test_files}"
  end
end

task :default => :test
