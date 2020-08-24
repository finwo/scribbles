.PHONY: docs
docs:
	mkdir -p docs
	# Ensure submodules are present
	git submodule update --init --recursive
	# Build pages
	find pages -mindepth 1 -maxdepth 1 -type d | sort | xargs -n 1 tool/custom/build-page.sh
