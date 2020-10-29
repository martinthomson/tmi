GITHUB_API_TOKEN := $(GITHUB_ACTOR):$(GITHUB_TOKEN)
LIBDIR := lib
include $(LIBDIR)/main.mk

$(LIBDIR)/main.mk:
ifneq (,$(shell grep "path *= *$(LIBDIR)" .gitmodules 2>/dev/null))
	git submodule sync
	git submodule update $(CLONE_ARGS) --init
else
	git clone -q --depth 10 $(CLONE_ARGS) \
	    -b main https://github.com/martinthomson/i-d-template $(LIBDIR)
endif

test::
	@echo 'SOURCE_BRANCH="$(SOURCE_BRANCH)"'
	@echo 'DEFAULT_BRANCH(make)="$(DEFAULT_BRANCH)"'
	@echo 'DEFAULT_BRANCH(shell)="$$DEFAULT_BRANCH"'
	@echo 'GITHUB_REF="$(GITHUB_REF)"'
	@echo 'GITHUB_USER="$(GITHUB_USER)"'
	@echo 'GITHUB_REPO="$(GITHUB_REPO)"'
	false
