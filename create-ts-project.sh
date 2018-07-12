 #!/bin/bash

PACKAGE_JSON_PATH=`pwd`/package.json
PRETTIER_RC_PATH=`pwd`/.prettierrc
TSLINT_JSON_PATH=`pwd`/tslint.json

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
    "jest": "23.4.0",
    "prettier": "1.13.7",
    "tslint": "5.10.0",
    "tslint-config-prettier": "1.13.0",
    "typescript": "2.9.2"
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

echo $PACKAGE_JSON > $PACKAGE_JSON_PATH
echo \"$PACKAGE_JSON_PATH\" created
echo

echo $PRETTIER_RC > $PRETTIER_RC_PATH
echo \"$PRETTIER_RC_PATH\" created
echo

echo $TSLINT_JSON > $TSLINT_JSON_PATH
echo \"$TSLINT_JSON_PATH\" created
echo

echo "Install dependencies (っ'ヮ'c)"

npm install
node_modules/.bin/tsc --init
node_modules/.bin/jest --init
npm run fmt

echo "Finished (੭•̀ᴗ•̀)"
