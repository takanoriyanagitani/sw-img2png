#!/bin/sh

inputurl='https://upload.wikimedia.org/wikipedia/commons/b/b2/Vulphere_WebP_OTAGROOVE_demonstration_2.webp'

input=./sample.d/Vulphere_WebP_OTAGROOVE_demonstration_2.webp

getinput(){
  echo getting input image data ${inputurl}...

  mkdir -p sample.d

  curl \
    --fail \
    --show-error \
    --location \
    "${inputurl}" |
    cat > "${input}"
}

test -f "${input}" || getinput

echo showing input file info...
file "${input}"
echo

export ENV_I_IMG_FILENAME="${input}"

export ENV_O_PNG_FILENAME=./sample.d/out.png

./ImageFileToPngFile

echo showing output file info...
file "${ENV_O_PNG_FILENAME}"
echo

echo printing file size...

ls -lSh \
  "${ENV_I_IMG_FILENAME}" \
  "${ENV_O_PNG_FILENAME}"
