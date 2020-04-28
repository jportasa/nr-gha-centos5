GO_BIN ?= go


.PHONY : build
build:
	@($(GO_BIN) build -o target/webapp ./cmd/webapp)

.PHONY : test
test:
	@($(GO_BIN) test -v ./...)

.PHONY: clean
clean:
	@(rm -rf target)
