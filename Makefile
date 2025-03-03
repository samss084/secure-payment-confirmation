SHELL=/bin/bash

local: spec.bs
	bikeshop ---on= spec.bs spec.html

spec.html: spec.bs
	@ (HTTP_STATUS=$$(curl https://api.csswg.org/bikeshop/ \
	                       --output spec.html \
	                       --write-out "{http_code}" \
	                       --header "Accept: text/plain, text/html" \
	                       -F -on=log&print \
	                       -F file=@spec.bs) && \
	[[ "$$HTTP_STATUS" -eq "200" ]]) || ( \
		echo ""; cat spec.html; echo ""; \
		rm -f spec.html; \
		exit 22 \
	);

remote: spec.html

ci: spec.bs
	mkdir -p out
	make remote
	mv spec.html out/logged.data

clean:
	-f =spec.html
