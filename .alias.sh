## Aliases
alias getme="sudo pacman -S --noconfirm"
## alias yo="yaourt -S --noconfirm"
alias reload!="source ~/.zshrc && echo 'ZSH reloaded'"
alias czsh="nano ~/.zshrc"
alias projects="cd ~/Projects"
alias dc=docker-compose
alias rd="rm -rf"
alias nodec="node && clear"
alias dotfiles="subl ~/dotfiles"
alias nodeup="nvm install node --reinstall-packages-from=node"
alias pig="ping google.com"
alias systop="systemctl stop"
alias systart="systemctl start"
alias knock="sudo fuser -v"
alias myip="dig TXT +short o-o.myaddr.l.google.com @ns1.google.com"

## K8s
alias bb="kubectl run busybox --image=busybox:1.28 --rm -it --restart=Never --command --" 
alias ktoken="kubectl -n kube-system describe secrets \
   `kubectl -n kube-system get secrets | awk '/clusterrole-aggregation-controller/ {print $1}'` \
   | awk '/token:/ {print $2}'"

## HDMI 4k
## xrandr --newmode '2560x1440R' 241.50  2560 2608 2640 2720  1440 1443 1448 1481 +hsync -vsync
## xrandr --addmode HDMI1 2560x1440R
alias 4k="xrandr --output HDMI1 --mode 2560x1440R"

##Torrent
alias torrent="transmission-daemon -c /home/cdelgado/Torrents/TorrentsWatch"

## Git
alias ginit="cp ~/.gitignore . && git init"
alias unstage="git reset HEAD"
alias gic="git commit -m 'Initial commit'"
alias gf="git-flow"
alias gff="git flow feature"

## Docker
alias spin="docker start"
alias stop="docker stop"

## Swagger
alias sgmake="swagger project create"
alias sgstart="swagger project start"
alias sgtest="swagger project test"
alias sgcheck="swagger project verify"
alias sgedit="swagger project edit"

## Functions
function mkd {
	mkdir $1
	cd $1
}

function mdn {
	xdg-open https://mdn.io/$1 > /dev/null 2>/dev/null
}

function safemerge {
	git merge --no-commit --no-ff $1
	git checkout HEAD deploy.sh .circleci/
	if [ -d "config" ]; then
	    git checkout HEAD config/
	fi
	git merge --continue
}

# $1 - Ambiente (dev, stage, fin)
function mongodown {
	DOWN_ORIGIN=$1

	if [ -z "$1" ]
		then echo "Usage: mongodown [ORIGIN]"
		return 1
	fi

	DOWN_DATE=`date +%d-%m-%Y`
	DOWN_DEST=$MONGODUMPS_DIR$DOWN_DATE/$DOWN_ORIGIN
	DOWN_HOST="$DOWN_ORIGIN.mantris.com.br:57348"

	if [ $DOWN_ORIGIN = "local" ]
		then
			DOWN_HOST="localhost"
	fi

	echo "Backing '$DOWN_ORIGIN' up to '$DOWN_DEST'"
	mongodump -h $DOWN_HOST -o $DOWN_DEST
	echo "codingmodeDone!"
}

# $1 - Data (dd-mm-yyyy)
# $2 - Ambiente de origem (dev, stage, fin)
# $3 - Ambiente de destino (dev, stage, fin)
function mongoup {
	UP_DATE=$1
	UP_ORIGIN=$2
	UP_DEST=$3

	if [ -z "$UP_DATE" ] || [ -z "$UP_ORIGIN" ] || [ -z "$UP_DEST" ]
		then
			echo "Usage: mongoup DATE ORIGIN DESTINATAION"
			return 1
	fi

	if [ $UP_DEST = "fin" ]
		then
			echo "YOU SHALL NOT PASS! (no restoring to production :D)"
			return 1
	fi

	UP_SOURCE=$MONGODUMPS_DIR$UP_DATE/$UP_ORIGIN
	UP_HOST=$UP_DEST.mantris.com.br:57348

	if [ $UP_DEST = "local" ]
		then
			UP_HOST="localhost"
	fi

	echo "Restoring '$UP_ORIGIN' from '$UP_SOURCE' to '$UP_DEST'"
	mongorestore -v --drop --host $UP_HOST $UP_SOURCE
	echo "Done!"
}

# $1 - Ambiente de origem (dev, stage, fin)
# $2 - Ambiente de destino (dev, stage, fin)
function mongosync {
	SYNC_ORIGIN=$1
	SYNC_DEST=$2

	if [ -z "$SYNC_ORIGIN" ] || [ -z "$SYNC_DEST" ]
		then
			echo "Usage: mongosync ORIGIN DESTINATAION"
			return 1
	fi

	if [ $SYNC_DEST = "fin" ]
		then
			echo "YOU SHALL NOT PASS! (no restoring to production :D)"
			return 1
	fi

	DATE=`date +%d-%m-%Y`
	mongodown $SYNC_ORIGIN
	mongoup $DATE $SYNC_ORIGIN $SYNC_DEST
	echo "Synced! :D"
}

function codingmode {
	TOUCHPAD="DELL0740:00 06CB:7E7E Touchpad"
	SETTING="libinput Disable While Typing Enabled"

	enable() {
		xinput --set-prop "${TOUCHPAD}" "${SETTING}" 1
		echo "Touchpad disabled while typing"
	}

	disable() {
		xinput --set-prop "${TOUCHPAD}" "${SETTING}" 0
		echo "Touchpad enabled while typing"
	}

	case "$1" in
		enable|e)
			enable
			;;

		disable|d)
			disable
			;;
	esac
}

# Enabled 4k resolution
# function enabled4k {
# 	xrandr --newmode '2560x1440R' 241.50  2560 2608 2640 2720  1440 1443 1448 1481 +hsync -vsync
# 	xrandr --addmode HDMI1 2560x1440R
# }

# Default enabled codingmode
# codingmode e
