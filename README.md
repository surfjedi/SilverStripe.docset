# SilverStripe Dash Docset

SilverStripe Docset for [Dash](http://kapeli.com/). 

This docset contains both the api.silverstripe.org documentation and written 
documentation from doc.silverstripe.org in a searchable archive. 

To add the latest documentation use the following export (which will be kept
relatively up to date through a weekly cron job).

	http://fullscreen.io/feeds/SilverStripe.docset.tgz

If you want to generate the documentation yourself, or need to add additional
modules, ensure that you have all the required dependencies:

	make setup

To produce a release run the makefile command produce:

	make produce

Or, run the ruby bin file (because I prefer ruby as a cli language):

	./bin/produce.rb

If you run the bin file directly you have the ability to define arguments to 
modify the script behavior. For instance, generating the API documentation takes 
several minutes on a Macbook i7 CPU so if you've already generated the API and 
doc documentation in the _working directory then you can pass `--use-working`
to use the current working directory and skip updating those directories from
the git update.

## Todo

[ ] Support multiple versions (3.1 / 3.2)
[ ] Document / explain how to add custom modules to local version
[ ] Resolve styling issues with both SilverStripe sites / including a responsive
stylesheet for smaller displays


