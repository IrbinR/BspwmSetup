#!/bin/bash

typeSystem(){
	local option=1
	linux=""
	while [[ $option != 0 ]]; do
		header
		msg "selected" "system"
		read -p "Ingrese una opción(1, 2, etc) o s(salir): " opt
		if [[ "$opt" == "1" ]]; then
			linux="debian"
		elif [[ "$opt" == "2" ]]; then
			linux="archlinux"
		elif [[ "$opt" == "s" ]]; then
			msg "status" "info"
			exit 0
		else
			clear
			msg "status" "error"
		fi

		[[ $(validateNumber "$opt" 2) -eq 0 ]] && break || :

	done
}

bar() {
	local left=$1
	local right=$2
	local default=$3
	local width=$4
	local last=$5
	local result=""
	for ((i = 0; i < "$width"; i++)); do
		if [[ $i -eq 0 ]]; then
			result+="$left"					
		elif [[ $i -eq $last ]]; then
			result+="$right"					
		else
			result+="$default"					
		fi
	done
	echo "$result"
}

view () {
	contornos=(╔ ╗ ╚ ╝ ═ ║)
	local type=$1
	local width=$2
	local last=$((width-1))
	local result=""
	if [[ "$type" == "top" ]]; then
		result=$(bar "${contornos[0]}" "${contornos[1]}" "${contornos[4]}" $width $last)
	elif [[ "$type" == "bottom" ]]; then
		result=$(bar "${contornos[2]}" "${contornos[3]}" "${contornos[4]}" $width $last)
	elif [[ "$type" == "space" ]]; then
		for ((i = 0; i < "$width"; i++)); do
			if [[ $i -eq 0 || $i -eq $last ]]; then
				result+="${contornos[5]}"					
			else
				result+=" "					
			fi
		done
	else
		local index=$3
		local text=$4
		local count=$((${#text} - 1))
		if [[ $index -ne 0 ]]; then
			local limite=$((5 + count))
			for ((i = 0; i < "$width"; i++)); do
				if [[ $i -eq 0 || $i -eq $last ]]; then
					result+="${contornos[5]}"					
				elif [[ $i -eq 1 || $i -eq 4 ]]; then
					result+=" "					
				elif [[ $i -eq 2 ]]; then
					result+="$index"					
				elif [[ $i -eq 3 ]]; then
					result+="."					
				elif [[ $i -eq 5 ]];  then
					result+="$text"
				elif [[ $i -le $limite ]];  then
					continue
				else
					result+=" "					
				fi
			done
		else
			local limite=$((2 + count))
			for ((i = 0; i < "$width"; i++)); do
				if [[ $i -eq 0 || $i -eq $last ]]; then
					result+="${contornos[5]}"					
				elif [[ $i -eq 1 ]]; then
					result+=" "					
				elif [[ $i -eq 2 ]]; then
					result+="$text"
				elif [[ $i -le $limite ]];  then
					continue
				else
					result+=" "					
				fi
			done
		fi
		
	fi
	echo "$result"
}

msg() {
	local textStyle=("ELIJA SU TEMA BSPWM PREFERIDO:" DARK CATPPUCCIN ARCHDARK YAZI)
	local textSystem=("ELIJA EL TIPO DE DISTRIBUCIÓN LINUX:" DEBIAN ARCHLINUX)
	local textStatus=("[INFO] SCRIPT FINALIZADO" "X ERROR: opción inválida" "CONTINUANDO CON LA INSTALACIÓN...")
 	local textSesion=("INSTRUCCIÓN DESPUÉS DE CERRAR SESIÓN:" "Se cerrara su sesión actual, por lo cual debera" "iniciar sesión nuevamente." "Después ejecute otra vez el script de instalación" "para poder continuar y completar con la instalación")

	local type=$1
	local result=""
	if [[ "$type" == "selected" ]]; then
		local width=51
		local text=$2
		local arrays=""
		if [[ "$text" == "style" ]]; then
			arrays=( "${textStyle[@]}")
		elif [[ "$text" == "system" ]]; then
			arrays=( "${textSystem[@]}" )
		fi

		for ((i = 0; i < 6; i++)); do
			if [[ $i -eq 0 ]]; then
				result+=$(view "top" $width)
			elif [[ $i -eq 1 || $i -eq 3 ]]; then
				result+=$(view "space" $width)
			elif [[ $i -eq 2 ]]; then
				result+=$(view "text" $width 0 "${arrays[0]}")
			elif [[ $i -eq 4 ]]; then
				local rows="${#arrays[@]}"
				local lastRows=$((rows - 1))
				for ((j = 1; j < $rows; j++)); do
					result+=$(view "text" $width $j "${arrays[$j]}")
					[[ $j -ne $lastRows ]] && result+="\n"
				done
			else
				result+=$(view "bottom" $width)
			fi
			result+="\n"
		done
	elif [[ "$type" == "sesion" ]]; then
		local width=55
		for ((i = 0; i < 6; i++)); do
			if [[ $i -eq 0 ]]; then
				result+=$(view "top" $width)
			elif [[ $i -eq 1 || $i -eq 3 ]]; then
				result+=$(view "space" $width)
			elif [[ $i -eq 2 ]]; then
				result+=$(view "text" $width 0 "${textSesion[0]}")
			elif [[ $i -eq 4 ]]; then
				local rows="${#textSesion[@]}"
				local lastRows=$((rows - 1))
				for ((j = 1; j < $rows; j++)); do
					result+=$(view "text" $width 0 "${textSesion[$j]}")
					[[ $j -ne $lastRows ]] && result+="\n"
				done
			else
				result+=$(view "bottom" $width)
			fi
			result+="\n"
		done
	else
			local width=37
			local status=$2
			for ((i = 0; i < 3; i++)); do
				if [[ $i -eq 0 ]]; then
					result+=$(view "top" $width)
				elif [[ $i -eq 1 ]]; then
					if [[ $status == "info" ]]; then
						result+=$(view "text" $width 0 "${textStatus[0]}")
					elif [[ $status == "error" ]]; then
						result+=$(view "text" $width 0 "${textStatus[1]}")
					else
						result+=$(view "text" $width 0 "${textStatus[2]}")
					fi
				else
					result+=$(view "bottom" $width)
				fi
				result+="\n"
			done
				
	fi
	echo -e "$result"
} 
                                              
validateNumber() {
	local number=$1
	local limite=$2
	if [[ "$number" =~ ^[0-9]+$ ]] && (( number >= 1 && number <= $limite )); then
		echo 0
	else
		echo 1
	fi

}

style(){                                      
	while [[ true ]]; do
		header
		msg "selected" "style"
		read -p "Ingrese una opción(1, 2, etc) o s(salir): " opt
		case "$opt" in
			1) 
				echo "INSTALANDO DARK"
			  ;;
			2) 
				echo "INSTALANDO CATPPUCCIN"
				;;
			3) 
				echo "INSTALANDO ARCHDARK"
				;;
			4) 
				echo "INSTALANDO YAZI"
				;;
			s)
				msg "status" "info"
        exit 0
				;;
			*) 
				clear
				msg "status" "error"
				;;
		esac
		
		[[ $(validateNumber "$opt" 4) -eq 0 ]] && break || :
		
	done
}

validatePathFont() {
	local directory=$1
	if [[ ! -d "$directory" ]]; then
		mkdir -p "$directory"
	fi
}

fuentesNerdFonts() {
	tmpDir=$(mktemp -d)
	local pathFonts="/usr/local/share/fonts"
	local gitlab="https://gitlab.com/irbinr1/fuentesnerdfonts.git"
	local repository="fuentesnerdfonts/NerdFonts"
	git clone --depth 1 "$gitlab" "$tmpDir"
	validatePathFont "$pathFonts/truetype"
	validatePathFont "$pathFonts/opentype"
	cp -rv "$tmpDir/$repository/TTF/*" "$pathFonts/truetype"
	cp -rv "$tmpDir/$repository/OTF/*" "$pathFonts/opentype"
	sudo fc-cache -fv
	trap 'rm -rf "$tmpDir"' EXIT
}

getUserDirs() {
	userDirs="$HOME/.config/user-dirs.dirs"
	if [[ -r "$userDirs" ]]; then
		source "$userDirs"
	else
		echo "Instalando xdg-user-dirs"
		sudo apt install -y xdg-user-dirs
		xdg-user-dirs-update
		source "$userDirs"
	fi
}

installXorg() {
	local packagesXorg=(xorg xserver-xorg xinit xterm)
	miniInstaller "${packagesXorg[@]}"
}

validateXorg() {
	if command Xorg --version >/dev/null 2>&1 || command X --version >/dev/null 2>&1; then
		return 0
	else
		return 1		
	fi
}

miniInstaller() {
	local manager subcommand flag
	read -r manager subcommand <<< "$(getParameters)"
	flag=$(confirm)
	sudo "$manager" "$subcommand" "$flag" "${@}"
}

installZsh() {
	mkdir -p "$LOGDIR"
	LOGFILE="$LOGDIR/zsh_install.log"

	if [[ -f "$LOGFILE" ]]; then
		LAST_STEP=$(tail -n 1 $LOGFILE)
	else
		LAST_STEP=0
	fi

	if [[ "$LAST_STEP" -lt 1 ]]; then
		miniInstaller zsh
		cat <<EOF >$LOGFILE
		1
EOF
	fi

	if [[ "$LAST_STEP" -lt 2 ]]; then
		sudo usermod --shell /usr/bin/zsh root
		sudo usermod --shell /usr/bin/zsh $USER
		if [[ ! -f "$HOME/.zshrc" ]]; then
		touch "$HOME/.zshrc"
		fi
		cat <<EOF >>$LOGFILE
		2
EOF
		msg "sesion"
		read -p "Presione ENTER para cerrar sesión "
		kill -9 -1
	fi

	if [[ "$LAST_STEP" -lt 3 ]]; then
		msg "status" "continuacion"
  	sleep 3
		zimfw_cmd="curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh"
		if command -v curl >/dev/null 2>&1; then
			(zimfw_cmd)
		else
			miniInstaller curl
			(zimfw_cmd)
		fi
		cat <<EOF >>$LOGFILE
		3
EOF
	fi

	if [[ "$LAST_STEP" -lt 4 ]]; then
		filePath="$HOME/.zimrc"
		sed -i "s|zmodule asciiship|#zmodule asciiship|" "$filePath"

		source "$HOME/.config/user-dirs.dirs"
		sudo pacman -S starship --noconfirm
		cat <<EOF
		========================================================
		|                       STARSHIP                       |
		========================================================
				eval "\$(starship init zsh)"
EOF
	fi
}

fileManager() {
	local desktop=$(echo "$XDG_CURRENT_DESKTOP")
	if [[ "$desktop" != "XFCE" ]]; then
		echo "thunar thunar-archive-plugin"
	elif [[ -z "$desktop" ]]; then
		validateXorg && installXorg || :
		echo "pcmanfm"
	else
		echo ""
	fi
}

getPackages() {
	local apps=(bspwm sxhkd rofi polybar feh picom dunst alacritty kitty mpd ncmpcpp fasfetch yazi htop lsd bat scrot xautolock lxappearance)
	local package=$(fileManager)
	if [[ -n "$package" ]]; then
		read -r -a packages <<< "$package"
		apps+=("${packages[@]}")
	fi
	echo "${apps[@]}"
}

appsAlternatives() {
	local appsAlternativas=(neovim)
}

typePackageManager() {
	local packageManager=("apt install" "pacman -S" "dnf install")
	echo "${packageManager[$1]}"
}

confirm() {
	local param=""
	if [[ "$linux" == "debian" || "$linux" == "fedora" ]]; then
		param="-y"
	elif [[ "$linux" == "archlinux" ]]; then
		param="--noconfirm"
	else
		param="-n"
	fi
	echo "$param"
}

getParameters() {
	local manager subcommand
	if [[ "$linux" == "debian" ]]; then
		IFS=' ' read -r manager subcommand <<< "$(typePackageManager 0)"
	elif [[ "$linux" == "archlinux" ]]; then
		IFS=' ' read -r manager subcommand <<< "$(typePackageManager 1)"
	else
		IFS=' ' read -r manager subcommand <<< "$(typePackageManager 2)"
	fi
	echo "$manager $subcommand"
}

installerPackage() {
	local packages=($(getPackages))
	local flag=$(confirm)
	local manager subcommand
	read -r manager subcommand <<< "$(getParameters)"
	sudo "$manager" "$subcommand" "$flag" "${packages[@]}"	
}

configSetup() {
	appsConfig=(bspwm dunst kitty alacritty mpd ncmpcpp fasfetch picom polybar rofi bat nvim bat lsd)
}

header(){
	cat <<EOF
╔═════════════════════════════════════════════════╗
║ ██████╗ ███████╗██████╗ ██╗    ██╗███╗   ███╗   ║
║ ██╔══██╗██╔════╝██╔══██╗██║    ██║████╗ ████║   ║
║ ██████╔╝███████╗██████╔╝██║ █╗ ██║██╔████╔██║   ║
║ ██╔══██╗╚════██║██╔═══╝ ██║███╗██║██║╚██╔╝██║   ║
║ ██████╔╝███████║██║     ╚███╔███╔╝██║ ╚═╝ ██║   ║
║ ╚═════╝ ╚══════╝╚═╝      ╚══╝╚══╝ ╚═╝     ╚═╝   ║
║                                                 ║
║  ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗  ║
║ ██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝  ║
║ ██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗ ║
║ ██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║ ║
║ ╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝ ║
║  ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝  ║
╚═════════════════════════════════════════════════╝
EOF
}

finish() {
	cat <<EOF
╔═════════════════════════════════════════════════╗
║                                                 ║
║    (‾⌣‾)ʕ·͡ᴥ·ʔ  SCRIPT COMPLETADO  (‾⌣‾)ʕ·͡ᴥ·ʔ    ║
║                                                 ║
╚═════════════════════════════════════════════════╝
EOF
}

init() {
	typeSystem
	# clear
	style
	#installZsh
	# fuentesNerdFonts
	# getPackages
	finish

}


# ╔═════════════════════════════════════════════════╗
# ║                                                 ║
# ║              INICIANDO INSTALADOR               ║
# ║                                                 ║
# ╚═════════════════════════════════════════════════╝
# LOGDIR="$HOME/.local/share/my_temp_scripts"
init
