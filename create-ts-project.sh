 #!/bin/bash

PACKAGE_JSON_PATH=`pwd`/package.json
PRETTIER_RC_PATH=`pwd`/.prettierrc
TSLINT_JSON_PATH=`pwd`/tslint.json
GIT_IGNORE_PATH=`pwd`/.gitignore

if [ -e $PACKAGE_JSON_PATH ]; then
    echo "Since package.json already exists, initialization processing is terminated."
    exit -1
fi

if [ -e $PRETTIER_RC_PATH ]; then
    echo "Since .prettierrc already exists, initialization processing is terminated."
    exit -1
fi

if [ -e $TSLINT_JSON_PATH ]; then
    echo "Since tslint.json already exists, initialization processing is terminated."
    exit -1
fi

if [ -e $GIT_IGNORE_PATH ]; then
    echo "Since .gitignore already exists, initialization processing is terminated."
    exit -1
fi

echo CWD=`pwd`
read -p "Are you sure you want to initialize this directory for the typescript project? [Y/n]" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
:
else
    echo "Canceled (>︿<｡)"
    exit
fi

echo
echo "Initiate... φ(•ᴗ•๑)"

PACKAGE_JSON=$(cat << EOS
{
  "name": "your-project-name-here",
  "version": "0.0.0",
  "description": "",
  "main": "dist/index.js",
  "scripts": {
    "build": "tsc",
    "test": "jest",
    "_fmt": "prettier --config .prettierrc '{*,src/**/*}.{js,jsx,css,ts,tsx,json}'",
    "_lint": "tslint -p ./tsconfig.json -c ./tslint.json 'src/**/*.{ts,tsx}'",
    "lint": "npm run _fmt && npm run _lint",
    "fmt": "npm run _fmt -- --write"
  },
  "keywords": [],
  "author": "",
  "license": "MIT",
  "dependencies": {
  },
  "devDependencies": {
    "@types/jest": "23.3",
    "jest": "23.4.2",
    "prettier": "1.14.0",
    "ts-jest": "23.1.0",
    "tslint": "5.11.0",
    "tslint-config-prettier": "1.14.0",
    "typescript": "3.0.1"
  }
}
EOS
)

PRETTIER_RC=$(cat << EOS
{
  "semi": false,
  "trailingComma": "all"
}
EOS
)

TSLINT_JSON=$(cat << EOS
{
  "defaultSeverity": "error",
  "extends": ["tslint:recommended", "tslint-config-prettier"],
  "jsRules": {},
  "rules": {
    "no-null-keyword": true,
    "jsx-no-lambda": false,
    "no-unused-variable": [true, { "ignore-pattern": "^_" }],
    "trailing-comma": false,
    "interface-name": [true, "never-prefix"],
    "member-ordering": false,
    "semicolon": [true, "never"],
    "arrow-parens": false,
    "object-literal-sort-keys": false,
    "ordered-imports": false,
    "no-non-null-assertion": false
  },
  "rulesDirectory": []
}
EOS
)

echo

echo "curl -s https://raw.githubusercontent.com/github/gitignore/master/Node.gitignore"
curl -s https://raw.githubusercontent.com/github/gitignore/master/Node.gitignore > $GIT_IGNORE_PATH
echo \"$GIT_IGNORE_PATH\" created
echo

echo $PACKAGE_JSON > $PACKAGE_JSON_PATH
echo \"$PACKAGE_JSON_PATH\" created
echo

echo $PRETTIER_RC > $PRETTIER_RC_PATH
echo \"$PRETTIER_RC_PATH\" created
echo

echo $TSLINT_JSON > $TSLINT_JSON_PATH
echo \"$TSLINT_JSON_PATH\" created
echo

mkdir -p src
touch src/index.ts
touch src/index.test.ts

echo "Install dependencies (っ'ヮ'c)"

npm install
node_modules/.bin/tsc --init
node_modules/.bin/jest --init
npm run fmt
npm outdated

echo "Finished (੭•̀ᴗ•̀)"
