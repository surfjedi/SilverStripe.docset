all:
	@echo "Available commands:"
	@grep "^[^#[:space:]].*:$$" Makefile | sort

setup:
	bundle install
	pear config-set auto_discover 1
	sudo pear install pear.apigen.org/apigen

produce:
	@./bin/produce.rb