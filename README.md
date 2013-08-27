Capistrano Deployment Tags
==========================
This plugin to Capistrano will add a timestamped Git tag
at each deployment, automatically.  It is intended to be used with
the multistage recipe and will tag each release by environment.
You can, however, use it without multistage simply by setting :branch
and :stage in your recipe.

What It Does
------------
Simply: it makes it so you can track your deployments from Git.
If I were to issue the command:

`cap production deploy`

This would result in one new git tag with the environment and
timestamp:

`production-2012.04.02-203155`

These tags can be used for any number of useful things including
generating statistics about deployments per day/week/year, tracking
code size over a period of time, detecting Rails migrations, and
probably a thousand other things I haven't thought of.

Usage
-----
capistrano-deploytags is available on
[rubygems.org](https://rubygems.org/gems/capistrano-deploytags).
You can install it from there with:

`gem install capistrano-deploytags`

If you use Bundler, be sure to add the gem to your Gemfile.
In your Capistrano `config/deploy.rb` you should add:

`require 'capistrano-deploytags'`

This will create two tasks, one that runs before deployment and one
that runs after.

NOTE: You will be creating and pushing tags from the version of the code in the
current checkout. This plugin needs to be run from a clean checkout of your
codebase. You should be deploying from a clean checkout anyway, so in most
cases this is not a restriction on how you already do things. The plugin will
check if your code is clean and complain if it is not.

Working on Your Deployment Scripts
----------------------------------
Because you must have a clean tree to deploy, working on your deployment
scripts themselves can be a bit frustrating unless you know how to make it
work. The easiest way around this problem is to simply commit your changes
before you deploy. You do not have to push them. The plugin will then
happily carry on deploying without complaint.

Viewing Deployment History
--------------------------
It's trivial to view the deployment history for a repo. From a checkout
of the repo, type `git tag -l -n1`. The output looks something like:

```
dev-2013.07.22-105130 baz deployed a4d522d9d to dev
dev-2013.07.22-113207 karl deployed 4c43f8464 to dev
dev-2013.07.22-114437 gavin deployed 776e15414 to dev
dev-2013.07.22-115103 karl deployed 619ff5724 to dev
dev-2013.07.22-144121 joshmyers deployed cf1ed1a02 to dev
```

A little use of `grep` and you can easily get the history for a
particular (e.g. `git tag -l -n1 | grep dev`).

It should be noted that the names used when tags are created are the
local user name on the box where the deployment is done.

Helpful Git Config
------------------
You might find it useful to add this to your ~/.gitconfig in order
to get a nice history view of the commits and tags.

```ini
[alias]
   lol = log --pretty=oneline --abbrev-commit --graph --decorate
```

You can then view the list by typing `git lol` from the checked out
code path.

Deploying a Previous Commit
---------------------------
Because you have to actually be on the head of the branch you are
deploying in order for tagging to work properly, deploying a previous
commit doesn't work as you might expect. The simple solution is to
create a new branch from the previous commit you wish to deploy and
supplying `-S branch=<new branch>` as arguments to Capistrano.

Credits
-------
This software was written by [Karl Matthias](https://github.com/relistan)
with help from [Gavin Heavyside](https://github.com/gavinheavyside) and the
support of [MyDrive Solutions Limited](http://mydrivesolutions.com).

License
-------
This plugin is released under the BSD two clause license which is
available in both the Ruby Gem and the source repository.
