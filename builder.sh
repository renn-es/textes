[ -z "$out" ] && {
    echo 'Please run this script through "nix build". Exiting.'
    exit 1
}

buildPhase() {
    mkdir "$out"
    for file in *.typ; do
        typst compile "$file"
        mv "${file%.typ}.pdf" "$out" 
    done
}

genericBuild

