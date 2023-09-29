init:
	git submodule init
	git submodule update

update: init
	git submodule foreach git pull origin master
	git pull

install dev: update
	@pip install -r requirements-dev.txt

install molpy:
	@pip install -e ./shared/molpy

install molbase:
	@pip install -e ./shared/molbase