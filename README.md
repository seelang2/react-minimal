# react-minimal
Minimal React project initialization shell script

With create-react-app being deprecated, I wanted a suitable replacement to create a React app from scratch with just the bare minimum required to get it up and running without needing anything like Vite or Next.js. I also wanted it to set up a live dev server running on port 3000 just like create-react-app. After a bit of Googling and some trial and error I came up with an instruction set to do a React setup. Then I got tired of doing the setup manually and so threw it all into the shell script you see here.

This is a Linux-based script that I use on MacOS. It won't work directly as is in Windows.

## Installation

Simply run the shell script. For convenience you may want to copy it into your /user/local/bin directory:
```
sudo cp init-min-react.sh /usr/local/bin/init-min-react
```
Make sure there are execute permissions if necessary using `chmod +x /usr/local/bin/init-min-react`.

## Usage
```
./init-min-react.sh project_name
```

A new directory `project_name` will be created in the current working directory and a new project initialized with three primary files - `index.html`, `index.js` and `App.js`. The directory structure is the same as `create-react-app`. 

A Git repository is also set up with an initial commit of the base setup.


