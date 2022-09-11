# GNU Make version >= 3.82
configs := .gitconfig .vimrc .tmux.conf .inputrc $(wildcard .tmuxinator/*)
targets := $(addprefix $(HOME)/,$(configs))
dirs := .tmuxinator
tgtdirs := $(addprefix $(HOME)/,$(dirs))

.ONESHELL:
.SHELLFLAGS := -ec

all: install

pre-git:
	sed -i.bak -E -e 's/(([0-9]{1,3}\.){3}[0-9]{1,3})(:[0-9]+)?/IP\3/g' -e 's/IP:[0-9]+/IP:PORT/g' .gitconfig

post-git:
	IP=$$(sed -n -E 's/^.*[^0-9](([0-9]{1,3}\.){3}[0-9]{1,3}).*$$/\1/p' .gitconfig.bak | uniq)
	PORT=$$(sed -n -E 's/^.*[^0-9](([0-9]{1,3}\.){3}[0-9]{1,3}):([0-9]+).*$$/\3/p' .gitconfig.bak | uniq)
	printf "IP:PORT=$${IP}:$$PORT\n"
	[ -z "$$IP" -o  -z "$$PORT" ] && { echo "no IP or PORT" && exit 1; }
	sed -i -E -e "s/IP/$$IP/g" -e "s/PORT/$$PORT/g" .gitconfig

$(targets): $(HOME)/%: %
	ln -sf `realpath $<` $@

$(targets): | $(tgtdirs)

$(tgtdirs):
	mkdir $@

install: $(targets)

clean:
	rm -rf $(targets) $(tgtdirs)

.PHONY: all pre-git post-git install clean
