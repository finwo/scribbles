#!/usr/bin/env bash

set -ex

PAGEDIR="${1}"

# Fetch page data
declare -A TOKENS
while IFS='=' read key value; do
  [ ! -z "$key" ] || continue
  TOKENS["$key"]="$value"
done <<< "$(tool/ini.sh ${PAGEDIR}/meta.ini)"

if [ ! -d "$PAGEDIR" ]; then
  exit 0
fi
shift

# Handle indexes
while [ "$#" -gt 0 ]; do
  tool/template.sh -c config.ini -c "${PAGEDIR}/meta.ini" -p partials "${1}" >> "${2}"
  shift 2
done

# Handle custom render
if [ -f "${PAGEDIR}/render.sh" ]; then
  bash "${PAGEDIR}/render.sh"
fi

# Handle markdown
if [ -f "${PAGEDIR}/content.md" ]; then
  echo "{{>page/precontent.hbs}}"                                                   >  "${PAGEDIR}/content.hbs"
  echo "<h1>{{page.title}}</h1>"                                                    >> "${PAGEDIR}/content.hbs"
  echo "<small>{{page.description}}</small>"                                        >> "${PAGEDIR}/content.hbs"
  echo "<p>"                                                                        >> "${PAGEDIR}/content.hbs"
  echo "Published: <span datetime="{{page.created}}">{{page.created}}</span><br />" >> "${PAGEDIR}/content.hbs"
  echo "</p>"                                                                       >> "${PAGEDIR}/content.hbs"
  echo "<hr />"                                                                     >> "${PAGEDIR}/content.hbs"
  smu < "${PAGEDIR}/content.md"                                                     >> "${PAGEDIR}/content.hbs"
  echo "{{>page/postcontent.hbs}}"                                                  >> "${PAGEDIR}/content.hbs"
fi

mkdir -p "docs/${TOKENS[page.id]}"
tool/template.sh -c config.ini -c "${PAGEDIR}/meta.ini" -p partials "${PAGEDIR}/content.hbs" > "docs/${TOKENS[page.id]}/index.html"

# Handle extra build steps
if [ -f "${PAGEDIR}/extra.sh" ]; then
  "${PAGEDIR}/extra.sh"
fi
