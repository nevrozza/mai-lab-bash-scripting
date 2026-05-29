#!/bin/bash


TEST_DIR=$1

if [ -z "$TEST_DIR" ]; then
    read -p "Введите путь до директории: " TEST_DIR
fi

if [ -z "$TEST_DIR" ]; then
    TEST_DIR="test_dir"
fi



mkdir -p "$TEST_DIR"

echo "Генерация тестовых файлов в каталоге $TEST_DIR..."

dd if=/dev/urandom of="$TEST_DIR/file1.txt" bs=512 count=10 2>/dev/null
dd if=/dev/urandom of="$TEST_DIR/file2.txt" bs=512 count=25 2>/dev/null
dd if=/dev/urandom of="$TEST_DIR/file3.txt" bs=512 count=5  2>/dev/null
dd if=/dev/urandom of="$TEST_DIR/file4.txt" bs=512 count=50 2>/dev/null

echo "На этом всё."

exit 0
