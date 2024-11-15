#!/bin/bash

# Creates a new React project as a subdir in the current dir
# If no project name is given as a parameter, the user is prompted to enter one

if [ $# != 1 ]; then
  echo -n "Project name> "
  read projectname
else
  projectname=$1
fi

mkdir ./$projectname
cd $projectname

npm init -y
git init
npm install react react-dom 
npm install --save-dev @babel/core @babel/preset-env @babel/preset-react
npm install --save-dev webpack webpack-cli webpack-dev-server babel-loader html-webpack-plugin
npm install --save-dev css-loader html-loader style-loader mini-css-extract-plugin

cat > .babelrc<< EOF
{
  "presets": [
    "@babel/preset-env",
    ["@babel/preset-react", {"runtime": "automatic"}]
  ]
}
EOF

cat > webpack.config.js<< EOF
const HtmlWebpackPlugin = require("html-webpack-plugin");
const path = require("path");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const devMode = process.env.NODE_ENV !== "production";

module.exports = {
  entry: path.join(__dirname, 'src/index.js'),
  output: {
    path: path.join(__dirname, 'dist'),
    filename: "bundle.js",
  },
  mode: "development",
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/, // This will load the tree from the entry point, If not required in the tree it won't copy or compile it to the bundle
        exclude: /node_modules/,
        use: {
          loader: "babel-loader",
        },
      },
      {
        test: /\.html$/,
        use: "html-loader"
      },
      {
        test: /\.(sa|sc|c)ss$/,
        use: [
          devMode ? "style-loader" : MiniCssExtractPlugin.loader,
          "css-loader",
        ],
      },
    ],
  },
  resolve: {
    extensions: [".js", ".jsx"], // Webpack uses resolve.extensions to generate all the possible paths to the module
  },
  devServer: {
    open: true,
    hot: true,  // hot reloading
    port: 3000,  // port on which server will run
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: "./public/index.html", // This will append our generated js bundle to the single index.html
    }),
  ],
};
EOF

cat > .gitignore<< EOF
# See https://help.github.com/articles/ignoring-files/ for more about ignoring files.

# dependencies
/node_modules
/.pnp
.pnp.js

# testing
/coverage

# production
/build
/dist

# misc
.DS_Store
.env.local
.env.development.local
.env.test.local
.env.production.local

npm-debug.log*
yarn-debug.log*
yarn-error.log*
EOF

node -e "
const { promisify } = require('util');
const fs = require('fs');
const readFile = promisify(fs.readFile);
const writeFile = promisify(fs.writeFile);

(async () => {
	data = await readFile('package.json');
	data = JSON.parse(data);
	data.scripts.start = 'webpack serve --mode development --open';
	data.scripts.build = 'webpack --mode production';
	await writeFile('package.json', JSON.stringify(data, false, 2));
})();
"

mkdir public
mkdir src

cat > ./public/index.html<< EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Minimal React App</title>
</head>
<body>
  <noscript>This app requires JavaScript to run.</noscript>
  <div id="root"></div>
</body>
</html>
EOF

cat > ./src/index.js<< EOF
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(<App />);

EOF

cat > ./src/App.js<< EOF
export default function App() {

  return (
    <div>App Works!</div>
  );
};
EOF

git add .
git commit -m "Base setup commit"


echo "Project setup complete.

    Start live dev server: npm start
    Build production code: npm build
"
