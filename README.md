[![Gem Version](https://badge.fury.io/rb/capistrano-deploytags.svg)](http://badge.fury.io/rb/capistrano-deploytags)

## Capistrano Deployment Tags

This plugin for Capistrano 3 will add a timestamped Git tag
at each deployment, automatically. It requires :branch and :stage to be set,
but as Capistrano 3 is multistage by default (unlike Cap 2) :stage should
already be set, but you can override the variable if you want to change the
name of the tag.

### Requires Capistrano 3

As of version 1.0.0, this plugin requires Cap 3. If you need a Capistrano
2 compatible version, then use `gem 'capistrano-deploytags', '~> 0.9.2'`

### What It Does

Simply: it makes it so you can track your deployments from Git.
If I were to issue the command:

`cap production deploy`

This would result in one new git tag with the environment and
timestamp:

`production-2012.04.02-203155-utc`

These tags can be used for any number of useful things including
generating statistics about deployments per day/week/year, tracking
code size over a period of time, detecting Rails migrations, and
probably a thousand other things I haven't thought of.

### Usage

capistrano-deploytags is available on
[rubygems.org](https://rubygems.org/gems/capistrano-deploytags).
In keeping with the pattern used by Capistrano itself and other plugins, add it
to the `development` group of your Gemfile with `require: false`:

```ruby
# Gemfile
group :development do
  gem 'capistrano-deploytags', '~> 1.0.0', require: false
end
```

Then require `capistrano/deploytags` in your Capfile

```
# Capfile
require 'capistrano/deploytags'
```

This will create two tasks, one that runs before the `deploy` task, and one
that runs after the `cleanup` task.

*NOTE:* You will be creating and pushing tags from the version of the code in the
current checkout. This plugin needs to be run from a clean checkout of your
codebase. You should be deploying from a clean checkout anyway, so in most
cases this is not a restriction on how you already do things. The plugin will
check if your code is clean and complain if it is not.

*ALSO:* The plugin will do a pull to make sure you have the code on your local
system that will actually be deployed before checking the tree for changes.
Know this ahead of time as this may affect how you deal with your deployment
branches.

### Setting the Remote

By default, Capistrano Deploytags will use the remote names `origin`. If you
use a different remote name, then you may change the `:git_remote` setting
from your `deploy.rb` or the stage.

### Working on Your Deployment Scripts

Because you must have a clean tree to deploy, working on your deployment
scripts themselves can be a bit frustrating unless you know how to make it
work. The easiest way around this problem is to simply commit your changes
before you deploy. You do not have to push them. The plugin will then
happily carry on deploying without complaint.

Alternatively, you could disable the plugin temporarily with one of the
methods described below.

### Disabling Tagging for a Stage

Sometimes you do not want to enable deployment tagging for a particular
stage. In that event, you can simply disable tagging by setting `no_deploytags`
like so:

```ruby
set :no_deploytags, true
```

You can also set this from the command line at any time with an environment
variable `cap stage deploy NO_DEPLOYTAGS=true`.

*NOTE:* this will disable the use of the plugin's functionality entirely for
that stage. The tasks will run, but will do nothing. This means that tasks that
are hooked to the Capistrano Deploytags tasks will also still run, but they may
find their expectations are not met with regards to the cleanliness of the git
tree.

### Customizing the Tag Format

You may override the time format in `deploy.rb` or your stage:

```ruby
set :deploytag_time_format, "%Y.%m.%d-%H%M%S-utc"
```

To use your local time and not UTC (so that ```Time.now``` and not ```Time.now.utc``` is used internally):

```ruby
set :deploytag_utc, false
```

### Customizing the Tag Commit Message

By default, Capistrano Deploytags will create a tag with a message that indicates
the local user name on the box where the deployment is done, and the hash of the
tagged commit. If you prefer to have a more detailed commit message you may override
the `:deploytag_commit_message` setting from your `deploy.rb`, e.g. 
`set :deploytag_commit_message, 'This is my commit message for the deployed tag'`

### Viewing Deployment History

It's trivial to view the deployment history for a repo. From a checkout
of the repo, type `git tag -l -n1`. The output looks something like:

```
dev-2013.07.22-105130 baz deployed a4d522d9d to dev
dev-2013.07.22-113207 karl deployed 4c43f8464 to dev
dev-2013.07.22-114437 gavin deployed 776e15414 to dev
dev-2013.07.22-115103 karl deployed 619ff5724 to dev
dev-2013.07.22-144121 josh deployed cf1ed1a02 to dev
```
A little use of `grep` and you can easily get the history for a
particular (e.g. `git tag -l -n1 | grep dev`).

It should be noted that the names used when tags are created are the
local user name on the box where the deployment is done.

### Helpful Git Config

You might find it useful to add this to your ~/.gitconfig in order
to get a nice history view of the commits and tags.

```ini
[alias]
   lol = log --pretty=oneline --abbrev-commit --graph --decorate
```

You can then view the list by typing `git lol` from the checked out
code path.

### Deploying a Previous Commit

Because you have to actually be on the head of the branch you are
deploying in order for tagging to work properly, deploying a previous
commit doesn't work as you might expect.

One simple solution is to configure your `config.rb` to accept an ENV var
override. Then if you need to deploy a previous commit you can check out that
commit (SHA or branch), and supply the var on the command line. e.g. with this
in your `config.rb`:

```ruby
set :branch,      ENV["REVISION"] || ENV["BRANCH_NAME"] || "master"
```

you can deploy a previous commit with

```shell
git checkout <previous-commit>
cap <stage> deploy REVISION=<previous-commit>
```

### Running from Jenkins

Because Jenkins will check out the code with the current revision
number you will be in a detached state. This causes the plugin to be
unhappy about the git tree. The solution is to add `-S branch=$GIT_COMMIT`
to the cap deploy line called from your Jenkins build. This will cause
the diffs and comparisons done by the deploytags gem to be correct.

### Credits

This software was written by [Karl Matthias](https://github.com/relistan)
with help from [Gavin Heavyside](https://github.com/gavinheavyside) and the
support of [MyDrive Solutions Limited](http://mydrivesolutions.com).

### License

This plugin is released under the BSD two clause license which is
available in both the Ruby Gem and the source repository.
