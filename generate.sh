#!/bin/bash


TEST_DIR=$1
FILES_COUNT=$2


if [ -z "$TEST_DIR" ]; then
    read -p "Введите путь до директории: " TEST_DIR
fi

if [ -z "$TEST_DIR" ]; then
    TEST_DIR="test_dir"
fi


if [ -z "$FILES_COUNT" ]; then
    FILES_COUNT=4
fi



mkdir -p "$TEST_DIR"

echo "Генерация тестовых файлов в каталоге $TEST_DIR..."

for i in $(seq 1 "$FILES_COUNT"); do
    dd if=/dev/urandom of="$TEST_DIR/file$i.txt" bs=512 count=25 2>/dev/null
done


dd if=/dev/urandom of="$TEST_DIR/file_small.txt" bs=512 count=5  2>/dev/null
dd if=/dev/urandom of="$TEST_DIR/file_medium.txt" bs=512 count=25 2>/dev/null
dd if=/dev/urandom of="$TEST_DIR/file_big.txt" bs=1М count=10 2>/dev/null

echo "На этом всё."

exit 0
