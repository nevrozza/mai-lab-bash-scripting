#!/bin/bash

# Доп. условия: 1 и 3: Запрос параметров, если они опущены, и вывод справки

# Доп. условие 3
if [[ "$1" == "?" || "$1" == "-h" || "$1" == "--help" ]]; then
	echo "Справка:"
	echo "Эта программа удаляет файлы в указанном каталоге до тех пор,"
	echo "пока суммарная длина удаленных файлов не станет больше или равна заданному числу блоков."
	echo "Синтаксис: $0 <каталог> <число_блоков>"
	exit 0
fi


TARGET_BLOCKS=""
DIRS=()

ADD_CURRENT_FOLDER=""
INTERACTIVE_MODE=""
QUIET_OUT="/dev/stdout"

while [[ -n "$1" ]]; do
	if [[ "$1" == "-i" || "$1" == "--interactive" ]]; then
		INTERACTIVE_MODE=1
	elif [[ "$1" == "-c"  || "$1" == "--current" ]]; then
		ADD_CURRENT_FOLDER=1
	elif [[ "$1" == "-q" || "$1" == "--quiet" ]]; then
		QUIET_OUT="/dev/null"
	elif [[ "$1" == "-b" || "$1" == "--blocks" ]]; then
		if [[ -n "$2" ]]; then
			TARGET_BLOCKS="$2"
			shift
		else
			echo "[Ошибка] Не указано число блоков после параметра"
			exit 1
		fi
	else
		DIRS+=("$1")
	fi

	shift
done 

# Доп. условие 1
if ((INTERACTIVE_MODE == 1)); then
#	if [ -z "$DIR" ]; then
#		read -p "Введите путь к каталогу: " DIR
#	fi

	if [ -z "$TARGET_BLOCKS" ]; then
		read -p "Введите число блоков: " TARGET_BLOCKS
	fi
fi

if (( ADD_CURRENT_FOLDER == 1 )); then
	DIRS+=("$PWD")
fi

if [[ ${#DIRS[@]} -eq 0 ]]; then
    	echo "[Ошибка] Не указано ни одной директории"
	exit 1
fi

if [[ -n "$TARGET_BLOCKS" ]]; then
	if ! [[ "$TARGET_BLOCKS" =~ ^[0-9]+$ ]]; then
		echo "[Ошибка] Число блоков должно быть положительным целым числом"
		exit 1
	fi
else
	echo "[Ошибка] Не указано число блоков"
	exit 1
fi

TOTAL_DELETED_BLOCKS=0
TOTAL_DELETED_FILES=0

for dir in "${DIRS[@]}"; do
	for file in "$dir"/*; do
		if [ -f "$file" ]; then
			# блоки по 512 байт
        		blocks=$(stat -c %b "$file")

        		rm "$file"
        		echo "Удален файл: $file (Размер: $blocks блоков)" > "$QUIET_OUT"

	        	TOTAL_DELETED_BLOCKS=$((TOTAL_DELETED_BLOCKS + blocks))
			TOTAL_DELETED_FILES=$((TOTAL_DELETED_FILES + 1))
        		if [ "$TOTAL_DELETED_BLOCKS" -ge "$TARGET_BLOCKS" ]; then
            			echo "------------------------------------------------" > "$QUIET_OUT"
				echo "Удалено файлов: $TOTAL_DELETED_FILES"
				echo "Удалено блоков: $TOTAL_DELETED_BLOCKS (Требовалось: $TARGET_BLOCKS)"
				echo "На этом всё."
            			exit 0
       			fi
    		fi
	done
done

echo "------------------------------------------------" > "$QUIET_OUT"
echo "В каталоге закончились файлы (удалено: $TOTAL_DELETED_FILES)"
echo "Всего удалено блоков: $TOTAL_DELETED_BLOCKS из требуемых $TARGET_BLOCKS"

