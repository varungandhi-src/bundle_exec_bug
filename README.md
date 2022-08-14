# Bug where bundle install disagrees with bundle install about paths

Reproduction steps:

```bash
# -- Setup --
RBENV_ROOT=local-ruby-2.7.6 MAKE_OPTS="-j 10" rbenv install 2.7.6

# Backup install directory before fiddling to avoid rebuilding.
tar -czf local-ruby-2.7.6-backup.tgz local-ruby-2.7.6

# Ruby 2.7.6 uses bundler 2.1.4, which is nearly 2yo. Update that
./local-ruby-2.7.6/versions/2.7.6/bin/gem update bundler

# -- Problem --
# Try to run `bundle install` + `bundle exec`:
bash -c "env - PATH='/usr/local/bin:/usr/sbin:/usr/bin:/bin' _RUBY_ROOT=./local-ruby-2.7.6 _BUNDLE=./local-ruby-2.7.6/versions/2.7.6/bin/bundle ./run.sh"
```

Output:

```
+ ./local-ruby-2.7.6/versions/2.7.6/bin/bundle --version
Bundler version 2.3.20
+ ./local-ruby-2.7.6/versions/2.7.6/bin/bundle install
Fetching gem metadata from https://rubygems.org/..
Resolving dependencies...
Using bundler 2.3.20
Fetching sorbet-static 0.5.10324 (universal-darwin-21)
Installing sorbet-static 0.5.10324 (universal-darwin-21)
Fetching sorbet 0.5.10324
Installing sorbet 0.5.10324
Bundle complete! 1 Gemfile dependency, 3 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
+ find ./local-ruby -name srb -type f
+ ./local-ruby-2.7.6/versions/2.7.6/bin/bundle exec 'echo $PATH'
/Users/varun/Code/play/bundle_exec_bug/local-ruby-2.7.6/versions/2.7.6/lib/ruby/gems/2.7.0/bin:/usr/local/bin:/usr/sbin:/usr/bin:/bin
+ ./local-ruby-2.7.6/versions/2.7.6/bin/bundle exec which srb
```

There is a discrepancy between where bundler installed `srb`
and where it is looking for `srb` based on the entry added to `$PATH`.
