#!/bin/bash
set -e

if [ ! -f "validator_cli.jar" ]; then
    echo "Downloading validator_cli.jar ..."
    curl -LJO https://github.com/hapifhir/org.hl7.fhir.core/releases/latest/download/validator_cli.jar
fi

tmp="/tmp/r4r5"
rm -rf "$tmp"
mkdir -p $tmp

$JAVA_HOME_17_X64 -jar validator_cli.jar -version 5.0 ./r5/r4-2-r5/*.fml -ig ./r5/r4-2-r5 -alt-version R4 -output $tmp -output-style compact-split

# first row is the header, second row is where the data starts
row=2
for fullpath in ./r5/r4-2-r5/*.fml; do
    filename="$(basename "$fullpath")"
    results=$(cat "$tmp/${filename%.*}.txt")
    # replace all linebreaks with literal \n for uploading to gsheets
    results="${results//$'\n'/\\n}"
    # store each map's results in a separate variable not to exceed size limit (48kb per variable)
    # variable name is the map name - 'VisionPrescription4to5.fml'
    echo "{$filename}={$results}" >> "$GITHUB_ENV"
    # store row # for the variable - 'VisionPrescription4to5.row'
    echo "{${filename%.*}.row}={$row}" >> "$GITHUB_ENV"
    ((row++))
done

