dir=$(pwd)
js=$(find "$dir" -maxdepth 1 -type f -name "package.json")
java=$(find "$dir" -maxdepth 1 -type f -name "gradlew.*")

if [ "$js" ]; then
    echo "Environnement Javascrit détecté."
    echo "Création du dossier 'test-results/'"

    mkdir -p test-results

    npm test -- --watch=false
    testResult=$?

    cp -r ./reports ./test-results

    exit $testResult
fi

if [ "$java" ]; then
    echo "Environnement Java détecté."
    echo "Création du dossier 'test-results/'"

    mkdir -p test-results

    ./gradlew clean test
    testResult=$?

    cp -r ./build/reports ./test-results
    exit $testResult
fi

exit 1
