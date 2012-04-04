Capistrano Deployment Tags
==========================
This plugin to Capistrano will add timestamped and latest Git tags
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

It would also result in moving or creating this tag:

`production-latest`

These tags can be used for any number of useful things including
generating statistics about deployments per day/week/year, tracking
code size over a period of time, detecting Rails migrations, and
probably a thousand other things I haven't thought of.

Usage
-----
If you use Bundler, be sure to add the gem to your Gemfile.
In your Capistrano `config/deploy.rb` you should add:

`require 'capistrano_deploytags'`

This will create two tasks, one that runs before deployment and one
that runs after.

NOTE: You will be creating and pushing tags from the version of the
code in the current checkout. This plugin needs to be run from a
clean checkout of your codebase. You should be deploying from a
clean checkout anyway, so in most cases this is not a restriction
on how you already do things. The plugin will check if your code
is clean and complain if it is not.

Credits
-------
This software was written by [Karl Matthias](https://github.com/relistan)
with help from [Gavin Heavyside](https://github.com/hgavin) and the
support of [MyDrive Solutions Limited](http://mydrivesolutions.com).

License
-------
This plugin is released under the BSD two clause license which is
available in both the Ruby Gem and the source repository.
