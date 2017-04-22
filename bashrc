# git
git() {
	if [[ $@ == "branch" ]]; then
		command git branch -vv
	elif [[ $@ == "remote" ]]; then
		command git remote -vv
	elif [[ $@ == "fetch" ]]; then
		command git fetch --all
	elif [[ $@ == "log" ]]; then
		command git log --graph --all --decorate --format=format:'%C(bold cyan)%h%C(reset) %C(bold green)(%ar)%C(reset) %C(bold magenta)%an%C(reset) %C(bold red)%d%C(reset) %n%C(white)%s%C(reset)%n'
	else
		command git "$@"
	fi
}

# json
from_json() {
	green=`tput setaf 2`
	reset=`tput sgr0`
	for f in "$@"
	do
		echo "${green}Expanding $f${reset}"
		cat $f | python -m json.tool > .temp.json
		rm $f
		mv .temp.json $f
	done
}

to_json() {
	green=`tput setaf 2`
	reset=`tput sgr0`
	for f in "$@"
	do
		echo "${green}Minifying $f${reset}"
		cat $f | json-minify > .temp.json
		rm $f
		mv .temp.json $f
	done
}

alias jsonlint="jsonlint --quiet"

# Make GIF
makegif() {
	scale=${2:-320}
	echo "Current scale is ${scale}"
	echo "Final scale is ${scale}"
	ffmpeg -y -i "$1" -vf fps=30,scale=${scale}:-1:flags=lanczos,palettegen ~/palette.png
	ffmpeg -y -i "$1" -i ~/palette.png -filter_complex "fps=30,scale=${scale}:-1:lanczos[x];[x][1:v]paletteuse" output.gif
	rm ~/palette.png
}
