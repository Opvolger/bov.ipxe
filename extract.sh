version="21.2"
url=https://mirrors.layeronline.com/linuxmint/stable/$version/linuxmint-$version-cinnamon-64bit.iso
filename=$(basename $url)
basedir=$(pwd)

echo "url: $url"
echo "filename: $filename"

if [[ -f "$filename" ]]; then
    echo "$filename exists."
else
    echo "download $filename."
    wget $url
fi


mkdir -p $basedir/pxe/linuxmint
mkdir -p $basedir/pxe/ipxe

if [[ ! -f "$basedir/pxe/linuxmint/.disk/info" ]] || ! grep -q $version "$basedir/pxe/linuxmint/.disk/info"; then
    rm $basedir/pxe/linuxmint -rf
    7z x $filename -o$basedir/pxe/linuxmint
    chmod -R u=rwx,go=rx $basedir/pxe/linuxmint
fi

if [[ -f "$basedir/pxe/$filename" ]]; then
    echo "$basedir/pxe/$filename exists."
else
    echo "cp $filename."
    cp $filename $basedir/pxe/$filename
fi
sed -i "s/linuxmintversion \"[0-9.]*/linuxmintversion \"$version/g" $(pwd)/pxe/ipxe/boot.ipxe