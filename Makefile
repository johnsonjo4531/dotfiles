all:
	stow --verbose --target=$$HOME --restow */ && ./post-stow

delete:
	stow --verbose --target=$$HOME --delete */

one_time_install:
	bash install.sh
