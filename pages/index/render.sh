#!/usr/bin/env bash

PAGEDIR="$(dirname $0)"

# Top of the page
tool/ini/template.sh -c config.ini -c "${PAGEDIR}/meta.ini" -p partials "${PAGEDIR}/head.hbs" >  "${PAGEDIR}/content.hbs"

# Render page list
PAGES=$(ls ${PAGEDIR}/..)
for page in $(ls "${PAGEDIR}/.." | grep -v index); do
  tool/ini/template.sh -c config.ini -c "${PAGEDIR}/../${page}/meta.ini" -p partials "${PAGEDIR}/item.hbs" >> "${PAGEDIR}/content.hbs"
done

# Close up the page
tool/ini/template.sh -c config.ini -c "${PAGEDIR}/meta.ini" -p partials "${PAGEDIR}/tail.hbs" >> "${PAGEDIR}/content.hbs"
