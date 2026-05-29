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


DIR=$1
TARGET_BLOCKS=$2


# Доп. условие 1
if [ -z "$DIR" ]; then
	read -p "Введите путь к каталогу: " DIR
fi

if [ -z "$TARGET_BLOCKS" ]; then
	read -p "Введите число блоков: " TARGET_BLOCKS
fi


if [ ! -d "$DIR" ]; then
	echo "[Ошибка] Директория '$DIR' не существует"
	exit 1
fi

if ! [[ "$TARGET_BLOCKS" =~ ^[0-9]+$ ]]; then
	echo "[Ошибка] Число блоков должно быть положительным целым числом"
	exit 1
fi

TOTAL_DELETED_BLOCKS=0

for file in "$DIR"/*; do
	if [ -f "$file" ]; then
			# блоки по 512 байт
        	blocks=$(stat -c %b "$file")

        	rm "$file"
        	echo "Удален файл: $file (Размер: $blocks блоков)"

        	TOTAL_DELETED_BLOCKS=$((TOTAL_DELETED_BLOCKS + blocks))

        	if [ "$TOTAL_DELETED_BLOCKS" -ge "$TARGET_BLOCKS" ]; then
            	echo "------------------------------------------------"
				echo "Удалено блоков: $TOTAL_DELETED_BLOCKS (Требовалось: $TARGET_BLOCKS)"
				echo "На этом всё."
            	exit 0
       		fi
    	fi
done


echo "------------------------------------------------"
echo "В каталоге закончились файлы"
echo "Всего удалено блоков: $TOTAL_DELETED_BLOCKS из требуемых $TARGET_BLOCKS"

