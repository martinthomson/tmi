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
	@echo 'DEFAULT_BRANCH="$(DEFAULT_BRANCH)"'
	@echo 'GITHUB_REF="$(GITHUB_REF)"'
	@echo 'GITHUB_USER="$(GITHUB_USER)"'
	@echo 'GITHUB_REPO="$(GITHUB_REPO)"'
	git rev-parse --abbrev-ref origin/HEAD
	git rev-parse --abbrev-ref HEAD
	@echo default-branch
	@-$(LIBDIR)/default-branch.py $(GITHUB_USER) $(GITHUB_REPO) $(GITHUB_API_TOKEN)
	@echo default-branch with push token
	@-$(LIBDIR)/default-branch.py $(GITHUB_USER) $(GITHUB_REPO) $(GITHUB_PUSH_TOKEN)
	@echo curl v1
	@-curl -u "$(GITHUB_PUSH_TOKEN)" "https://api.github.com/repos/$(GITHUB_USER)/$(GITHUB_REPO)"
	false
