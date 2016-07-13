
all:
	@echo try setup, run, check and package

run:
	love .

package:
	rm -f flappybalt.love
	(find -name "*.lua" ; find assets/) | xargs zip flappybalt.love
	# test it:
	ls -l flappybalt.love
	love flappybalt.love

setup:
	sudo apt install love lua-check

check:
	luacheck . -i love -d -a
