# Pass 1: Files that have DateTimeOriginal (usually photos)
exiftool -r -overwrite_original -if 'defined $DateTimeOriginal' \
'-FileModifyDate<DateTimeOriginal' \
'-CreateDate<DateTimeOriginal' \
'-ModifyDate<DateTimeOriginal' \
'-TrackCreateDate<DateTimeOriginal' \
'-TrackModifyDate<DateTimeOriginal' \
/path/to/folder

# Pass 2: Files that have MediaCreateDate (usually videos)
exiftool -r -overwrite_original -if 'defined $MediaCreateDate' \
'-FileModifyDate<MediaCreateDate' \
'-CreateDate<MediaCreateDate' \
'-ModifyDate<MediaCreateDate' \
'-TrackCreateDate<MediaCreateDate' \
'-TrackModifyDate<MediaCreateDate' \
/path/to/folder

# Pass 3: Touch files to ensure filesystem reflects the changes
# Do only if needed 
while IFS= read -r file; do
    orig_date=$(exiftool -s3 -MediaCreateDate "$file" 2>/dev/null \
                 || exiftool -s3 -DateTimeOriginal "$file" 2>/dev/null)
    if [[ -n "$orig_date" ]]; then
        # Format into YYYY-MM-DD HH:MM:SS for touch
        date_fmt=$(echo "$orig_date" | sed 's/:/-/; s/:/-/;')
        touch -d "$date_fmt" "$file"
    fi
done < <(find /path/to/folder -type f \( \
    -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.heic' \
    -o -iname '*.tif' -o -iname '*.tiff' -o -iname '*.webp' \
    -o -iname '*.mp4' -o -iname '*.mov' -o -iname '*.avi' \
    -o -iname '*.mkv' -o -iname '*.wmv' -o -iname '*.mts' \
\))
