# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: vanta android ios vanta-cross swarm evm all test clean
.PHONY: vanta-linux vanta-linux-386 vanta-linux-amd64 vanta-linux-mips64 vanta-linux-mips64le
.PHONY: vanta-linux-arm vanta-linux-arm-5 vanta-linux-arm-6 vanta-linux-arm-7 vanta-linux-arm64
.PHONY: vanta-darwin vanta-darwin-386 vanta-darwin-amd64
.PHONY: vanta-windows vanta-windows-386 vanta-windows-amd64
##export GOPATH=$(pwd)
GOBIN = $(shell pwd)/build/bin
GO ?= latest

vanta:
	build/env.sh go run build/ci.go install ./cmd/vanta
	@echo "Done building."
	@echo "Run \"$(GOBIN)/vanta\" to launch vanta."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/vanta.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/vanta.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

clean:
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/kevinburke/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go get -u github.com/golang/protobuf/protoc-gen-go
	env GOBIN= go install ./cmd/abigen
	@type "npm" 2> /dev/null || echo 'Please install node.js and npm'
	@type "solc" 2> /dev/null || echo 'Please install solc'
	@type "protoc" 2> /dev/null || echo 'Please install protoc'

# Cross Compilation Targets (xgo)

vanta-cross: vanta-linux vanta-darwin vanta-windows vanta-android vanta-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/vanta-*

vanta-linux: vanta-linux-386 vanta-linux-amd64 vanta-linux-arm vanta-linux-mips64 vanta-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/vanta-linux-*

vanta-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/vanta
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/vanta-linux-* | grep 386

vanta-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/vanta
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/vanta-linux-* | grep amd64

vanta-linux-arm: vanta-linux-arm-5 vanta-linux-arm-6 vanta-linux-arm-7 vanta-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/vanta-linux-* | grep arm

vanta-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/vanta
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/vanta-linux-* | grep arm-5

vanta-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/vanta
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/vanta-linux-* | grep arm-6

vanta-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/vanta
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/vanta-linux-* | grep arm-7

vanta-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/vanta
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/vanta-linux-* | grep arm64

vanta-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/vanta
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/vanta-linux-* | grep mips

vanta-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/vanta
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/vanta-linux-* | grep mipsle

vanta-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/vanta
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/vanta-linux-* | grep mips64

vanta-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/vanta
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/vanta-linux-* | grep mips64le

vanta-darwin: vanta-darwin-386 vanta-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/vanta-darwin-*

vanta-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/vanta
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/vanta-darwin-* | grep 386

vanta-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/vanta
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/vanta-darwin-* | grep amd64

vanta-windows: vanta-windows-386 vanta-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/vanta-windows-*

vanta-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/vanta
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/vanta-windows-* | grep 386

vanta-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/vanta
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/vanta-windows-* | grep amd64
