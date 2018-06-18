all: lint vet test getsamplemar testparser testsigner

lint:
	golint go.mozilla.org/mar

vet:
	go vet -composites=false go.mozilla.org/mar

test:
	go test -covermode=count -coverprofile=coverage.out go.mozilla.org/mar

coverage: test
	go tool cover -html=coverage.out

getkeys:
	bash get_firefox_keys.sh

getsamplemar:
	@if [ ! -e firefox-60.0esr-60.0.1esr.partial.mar ]; then \
		wget http://download.cdn.mozilla.net/pub/firefox/releases/60.0.1esr/update/win64/en-US/firefox-60.0esr-60.0.1esr.partial.mar ;\
	fi

testparser:
	go run -ldflags "-X go.mozilla.org/mar.debug=true" examples/parse.go firefox-60.0esr-60.0.1esr.partial.mar 2>&1 | grep 'signature: OK, valid signature from release1_sha384'

testsigner:
	go run -ldflags "-X go.mozilla.org/mar.debug=true" examples/sign.go firefox-60.0esr-60.0.1esr.partial.mar /tmp/resigned.mar
	go run examples/parse.go /tmp/resigned.mar

getmarcorpus:
	wget -P /tmp http://download.cdn.mozilla.net/pub/firefox/releases/1.5/update/win32/en-US/firefox-1.5rc2-1.5.partial.mar
	wget -P /tmp http://download.cdn.mozilla.net/pub/firefox/releases/10.0.1esr/update/linux-x86_64/fr/firefox-10.0esr-10.0.1esr.partial.mar
	wget -P /tmp http://download.cdn.mozilla.net/pub/firefox/releases/2.0.0.1/update/win32/en-US/firefox-2.0.0.1.complete.mar
	wget -P /tmp http://download.cdn.mozilla.net/pub/firefox/releases/2.0.0.1/update/mac/ru/firefox-2.0-2.0.0.1.partial.mar
	wget -P /tmp http://download.cdn.mozilla.net/pub/firefox/releases/3.5.14/update/win32/fy-NL/firefox-3.5.13-3.5.14.partial.mar
	wget -P /tmp http://download.cdn.mozilla.net/pub/firefox/releases/36.0b5/update/linux-i686/ga-IE/firefox-36.0b4-36.0b5.partial.mar
	wget -P /tmp http://download.cdn.mozilla.net/pub/firefox/releases/4.0rc2/update/win32/sv-SE/firefox-4.0rc1-4.0rc2.partial.mar
	wget -P /tmp http://download.cdn.mozilla.net/pub/firefox/releases/60.0.1esr/update/win64/en-US/firefox-60.0esr-60.0.1esr.partial.mar

testmarcorpus:
	for f in $$(ls /tmp/firefox*.mar); do go run examples/parse.go "$$f"; done

.PHONY: all lint vet test getkeys getsamplemar testparser

