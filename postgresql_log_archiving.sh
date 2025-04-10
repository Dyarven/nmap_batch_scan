#!/bin/bash
# Antes de usar este script de arquivado, comprobar a política de rotación de logs definida no motor de postgresql con:
# SELECT name, setting FROM pg_settings WHERE name LIKE 'log_%';

set -eo pipefail        # Detén a execución se falla algo no script

LOG_DIR="/pgdb/logs"
RETENTION_YEARS=1
MONTHS=("" "enero" "febrero" "marzo" "abril" "mayo" "junio" "julio" "agosto" "septiembre" "octubre" "noviembre" "diciembre")

get_month() {
    printf "%s" "${MONTHS[$1]}"
}

# Borra logs vacíos que teñan máis de 48h (para evitar borrar algún aberto e que vaian nos .tar.gz a posteriori)
find "$LOG_DIR" -name "postgresql-*.log*" -type f -empty -mtime +1 -delete

# Procesa logs por mes/ano
current_year=$(date +%Y)
current_month=$(date +%m)

# Usar un array asociativo para agrupar os nomes dos ficheiros por archivo de arquivo (tar)
declare -A files_by_archive

# Recoller os ficheiros elixibles (todos os que teñan máis de 1 mes)
while IFS= read -r filepath; do
    # Comprobar se o ficheiro aínda existe
    if [ ! -f "$filepath" ]; then
        echo "Ignorando $filepath porque non existe"
        continue
    fi
    filename=$(basename "$filepath")

    # Extraer data
    if [[ $filename =~ postgresql-([0-9]{4})-([0-9]{2})- ]]; then
        year="${BASH_REMATCH[1]}"
        month="${BASH_REMATCH[2]}"
        month_num=$((10#$month))
        age=$(( (current_year - year) * 12 + (current_month - month_num) ))
        if [ $age -gt 1 ]; then
            month_name=$(get_month $month_num)
            archive_name="postgresql-${year}-${month_name}.tar.gz"
            # Engadir o nome do ficheiro ao grupo correspondente
            files_by_archive["$archive_name"]+="$filename"$'\n'
        fi
    fi
done < <(find "$LOG_DIR" -name "postgresql-*.log*" -type f)

# Crear o arquivo tar para cada mes, unha vez que se teñan recollido todos os ficheiros
for archive in "${!files_by_archive[@]}"; do
    file_list="${files_by_archive[$archive]}"
    echo "Creating archive $archive with files:"
    echo "$file_list"
    # Meter lista de nomes en array
    mapfile -t file_array <<< "$file_list"

    # Filtrar entradas baleiras
    filtered_files=()
    for file in "${file_array[@]}"; do
        if [ -n "$file" ] && [ -f "${LOG_DIR}/${file}" ]; then
            filtered_files+=("$file")
        fi
    done

    if [ ${#filtered_files[@]} -eq 0 ]; then
        echo "Nada que arquivar de $archive (ignorando)"
        continue
    fi

    tar -czf "${LOG_DIR}/${archive}" -C "$LOG_DIR" "${filtered_files[@]}" --owner=postgres --group=postgres
    if [ $? -eq 0 ]; then
        # Se a compresión foi ben, borra os ficheiros orixinais
        for file in "${filtered_files[@]}"; do
            rm -fv "${LOG_DIR}/${file}"
        done
    fi
done

# Borrar arquivos de fai máis de un ano
find "$LOG_DIR" -name "postgresql-*.tar.gz" -type f -mtime +$((RETENTION_YEARS * 365)) -delete
