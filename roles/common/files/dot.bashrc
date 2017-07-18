while read filename
do
  source "$filename"
done < <(find -L ~/.bashrc.d -type f)
