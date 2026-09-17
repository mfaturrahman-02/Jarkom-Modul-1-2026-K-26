#!/bin/bash

if [ -z "$1" ]; then
    echo "Penggunaan: $0 <file_hex.txt>"
    exit 1
fi

file_input="$1"

if [ ! -f "$file_input" ]; then
    echo "Error: File '$file_input' tidak ditemukan!"
    exit 1
fi

while IFS= read -r hex || [ -n "$hex" ]; do
    hex_clean=$(echo "$hex" | tr -d ':')

    # Ambil Modifier (byte 1) dan Keycode (byte 3)
    mod="${hex_clean:0:2}"
    byte="${hex_clean:4:2}"

    if [ -n "$byte" ] && [ "$byte" != "00" ]; then
        code=$((16#$byte))
        mod_code=$((16#$mod))

        # Cek apakah Shift aktif (Left Shift 0x02 atau Right Shift 0x20)
        is_shift=0
        if [ $((mod_code & 0x22)) -ne 0 ]; then
            is_shift=1
        fi

        if [ $code -ge 4 ] && [ $code -le 29 ]; then
            # Huruf a-z / A-Z
            if [ $is_shift -eq 1 ]; then
                printf "\\$(printf '%03o' $((code + 61)))"
            else
                printf "\\$(printf '%03o' $((code + 93)))"
            fi
        elif [ $code -ge 30 ] && [ $code -le 39 ]; then
            # Angka / Simbol atas angka
            if [ $is_shift -eq 1 ]; then
                case $code in
                    30) printf "!" ;; 31) printf "@" ;; 32) printf "#" ;;
                    33) printf "$" ;; 34) printf "%%" ;; 35) printf "^" ;;
                    36) printf "&" ;; 37) printf "*" ;; 38) printf "(" ;;
                    39) printf ")" ;;
                esac
            else
                if [ $code -eq 39 ]; then printf "0"; else printf "$((code - 29))"; fi
            fi
        else
            # Tombol Spesial Lainnya
            case $code in
                40) echo "" ;;          # Enter
                44) printf " " ;;       # Spasi
                45) [ $is_shift -eq 1 ] && printf "_" || printf "-" ;;
                46) [ $is_shift -eq 1 ] && printf "+" || printf "=" ;;
                47) [ $is_shift -eq 1 ] && printf "{" || printf "[" ;;
                48) [ $is_shift -eq 1 ] && printf "}" || printf "]" ;;
                51) [ $is_shift -eq 1 ] && printf ":" || printf ";" ;;
                52) [ $is_shift -eq 1 ] && printf '"' || printf "'" ;;
                54) [ $is_shift -eq 1 ] && printf "<" || printf "," ;;
                55) [ $is_shift -eq 1 ] && printf ">" || printf "." ;;
                56) [ $is_shift -eq 1 ] && printf "?" || printf "/" ;;
            esac
        fi
    fi
done < "$file_input"

echo ""
