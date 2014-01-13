all:
	@echo "Available commands:"
	@grep "^[^#[:space:]].*:$$" Makefile | sort

setup:
	pear config-set auto_discover 1
	sudo pear install pear.apigen.org/apigen
