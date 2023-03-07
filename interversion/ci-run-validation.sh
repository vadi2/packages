#!/bin/bash
set -e

if [ ! -f "validator_cli.jar" ]; then
    echo "Downloading validator_cli.jar ..."
    curl -LJO https://github.com/hapifhir/org.hl7.fhir.core/releases/latest/download/validator_cli.jar
fi

# first row is the header, second row is where the data starts
row=2
for map in ./interversion/r5/r4-2-r5/*; do
    # output=$(java -jar validator_cli.jar -version 4.0 ./interversion/r5/r4-2-r5/MedicationStatement.fml -ig ./interversion/r5/r4-2-r5 -alt-version R5 2>&1)

    output="test"
    echo "Uploading results $map to $row"

    ((row++))
done
