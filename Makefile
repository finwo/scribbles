.PHONY: docs
docs:
	mkdir -p docs
	# Ensure submodules are present
	git submodule update --init --recursive
	# Build pages
	find pages -mindepth 1 -maxdepth 1 -type d | sort | xargs -n 1 tool/custom/build-page.sh
	# # Build blog
	# tool/ini/template.sh -c config.ini -p partials partials/index.head.hbs > docs/index.html
	# tool/ini/template.sh -c config.ini -p partials partials/rss.head.hbs   > docs/rss.xml
	# find posts -mindepth 1 -maxdepth 1 -type d | sort -r | xargs -n 1 -I@ tool/custom/build-page.sh @ partials/index.item.hbs docs/index.html partials/rss.item.hbs docs/rss.xml
	# tool/ini/template.sh -c config.ini -p partials partials/index.tail.hbs >> docs/index.html
	# tool/ini/template.sh -c config.ini -p partials partials/rss.tail.hbs   >> docs/rss.xml
	# Copy static assets
	# cp -r assets docs/
