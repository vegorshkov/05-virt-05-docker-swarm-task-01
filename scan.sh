#!/bin/bash

# Переменные
output_file="../sec-inf.txt"
current_dir="./"

# Очищаем или создаем выходной файл
> "$output_file"

# Функция для рекурсивного обхода каталогов
traverse_dir() {
    local dir="$1"
    local indent="$2"
    
    # Перебираем все элементы в каталоге (включая скрытые)
    for item in "$dir"/* "$dir"/.[!.]* "$dir"/..?*; do
        # Пропускаем несуществующие (когда шаблоны не нашли файлы)
        [ -e "$item" ] || continue
        
        # Получаем базовое имя элемента
        local base_name=$(basename "$item")
        
        # Пропускаем . и ..
        if [ "$base_name" = "." ] || [ "$base_name" = ".." ]; then
            continue
        fi
        
        # Записываем информацию об элементе
        if [ -d "$item" ]; then
            # Это каталог
            echo "${indent}[DIR] $item" >> "$output_file"
            # Рекурсивно обходим подкаталог
            traverse_dir "$item" "$indent    "
        elif [ -f "$item" ]; then
            # Это файл
            echo "${indent}[FILE] $item" >> "$output_file"
            
            # Пытаемся прочитать файл, если это текстовый файл
            if [ -r "$item" ] && [[ "$(file -b --mime-type "$item")" == text/* ]]; then
                echo "${indent}Содержимое файла $item:" >> "$output_file"
                echo "${indent}========================================" >> "$output_file"
                # Добавляем отступ к каждой строке содержимого
                cat "$item" 2>/dev/null | sed "s/^/${indent}/" >> "$output_file" 2>/dev/null
                echo "${indent}========================================" >> "$output_file"
            else
                echo "${indent}Нечитаемый файл или бинарный файл" >> "$output_file"
            fi
        elif [ -L "$item" ]; then
            # Это символическая ссылка
            echo "${indent}[LINK] $item -> $(readlink "$item")" >> "$output_file"
        else
            # Другие типы файлов
            echo "${indent}[OTHER] $item" >> "$output_file"
        fi
    done
}

# Запускаем обход с текущего каталога
echo "Начало сканирования каталога: $current_dir" >> "$output_file"
echo "Время: $(date)" >> "$output_file"
echo "========================================" >> "$output_file"

traverse_dir "$current_dir" ""

echo "Сканирование завершено." >> "$output_file"
echo "Результат сохранен в: $output_file" >> "$output_file"
