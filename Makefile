PREFIX ?= /etc/openvpn/scripts

SRC = update-systemd-resolved
DEST = $(DESTDIR)$(PREFIX)/$(SRC)

WRP = vpnstart
DSTW = /usr/loca/bin/${WRP}

.PHONY: all install info

all: install info

install:
	@install -Dm750 $(SRC) $(DEST)
	@install -Dm644 $(SRC).conf $(DEST).conf
	@install -Dm777 ${WRP} ${DSTW}

info:
	@printf 'Successfully installed %s to %s.\n' $(SRC) $(DEST)
	@echo
	@echo   'Now would be a good time to update /etc/nsswitch.conf:'
	@echo
	@echo   '  # Use systemd-resolved first, then fall back to /etc/resolv.conf'
	@echo   '  hosts: files resolve dns myhostname'
	@echo   '  # Use /etc/resolv.conf first, then fall back to systemd-resolved'
	@echo   '  hosts: files dns resolve myhostname'
	@echo
	@echo   'You should also update your OpenVPN configuration:'
	@echo
	@printf '  setenv PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\n'
	@echo   '  script-security 2'
	@printf '  up %s\n' $(DEST)
	@echo   '  up-restart'
	@printf '  down %s\n' $(DEST)
	@echo   '  down-pre'
	@echo
	@echo   '  save your config in ~/bin/vpnstart.{USER}.ovpn'
	@echo   '  start vpn with vpnstart ${USER}'
	@printf 'or pass --config %s.conf\n' $(DEST)
	@echo 'in addition to any other --config arguments to your openvpn command.'
