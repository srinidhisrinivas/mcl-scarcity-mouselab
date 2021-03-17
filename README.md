# Mouselab MDP

## Publishing your code

1. Go through the directory to make sure there is no private data which accidentally snuck in
2. Remove the config.txt (uncomment out .gitignore line) or remove the lines in the config.txt which are secret

#TODO please add to this checklist!

## Requirements

The Coffeescript files in src should be able to compile into javascript using `make`. In order to download the most recent version of Coffeescript which has more support for async, download Coffeescript from the npm package manager:

- https://www.npmjs.com/get-npm
- https://www.npmjs.com/package/coffeescript

You can use any Javascript plugins that work with jsPsych v6.3.0. Look at the plugins in static/js/jsPsych and the jsPsych documentation if you want to create your own.

To get started with running the flask app, create a psiturk virtual environment or conda environment and install psiturk:

```
pip install psiturk
```

## Origins

Fred's Web of Cash plugin: https://github.com/fredcallaway/Mouselab-MDP
RLDM paper: https://osf.io/7wcya/

## Setup

 Go through these two atlas pages:
   - https://atlas.is.localnet/confluence/display/REG/How+to+run+a+psiTurk+experiment
   - https://atlas.is.localnet/confluence/pages/viewpage.action?pageId=83136263
  
In short. you will need to:

1. Create a Heroku app, and attache the mouselab mdp database
```
    heroku create YOUR_APP_NAME --buildpack heroku/python --region eu
    heroku git:remote -a YOUR_APP_NAME
    heroku addons:attach mouselabmdp-database::DATABASE --app <your-app-name>

```

2. Follow the steps from step 6 in the psiturk + heroku documentation: https://psiturk.readthedocs.io/en/python2/heroku.html)


### Post HITs (if not using CloudResearch)

Start the psiturk shell with the command `psiturk`. Run `hit create 30 1.50 0.5` to create 30 hits, each of which pays $1.50 and has a 30 minute time limit. You'll get a warning about your server not running. You are using an external server process, so you can press `y` to bypass the error message.

## Editing

The main part of the project is the `experiment.coffee` file, in the `src` folder.
You can read the comments to understand which part does what.
The file is written in CoffeeScript (basically JavaScript with simplified syntax).
[Here](https://coffeescript.org/) you can install the tool and find out more about it.
Before running the experiment it is important to transpile that file to JavaScript
because browsers cannot understand CoffeeScript. If you find some code examples online that are in JavaScript and want to use them in CoffeeScript you can use an online converter like [this one](http://js2.coffee/).

Open a terminal window and type `cd ` and then type or paste the path to this project's folder on your machine. For example `cd ~/Documents/work/mouselab-mdp-example/` (`~` is the short way to refer to your home directory). Press enter to run the command. This will change your working directory.
After making some changes in the source file you should run `coffee -o static/js/experiment.js -cb src/experiment.coffee` in the terminal.
This will use the output (`-o`) file `experiment.js`, which will be used by the browser.
Note that it is possible to change the code in `experiment.js` directly, but when this command is run it will overwrite the old output file, so you should avoid this.
If you are making frequent changes and want CoffeeScript to be automatically transpiled every time you save your changes you can run `coffee -o static/js/experiment.js -cbw src/experiment.coffee` instead. The `w` option stands for `--watch` (watch all the changes and update the JS file automatically).

In the current example, you can find the variable `experiment_timeline`. It's the array
of blocks (steps) that you want to have in your experiment. You can include different
types of blocks (like `text` or `mouselab-mdp`). Each block has additional options that
you can customize. You can also load blocks from an external file. In the example some
additional trials are loaded from the files in `static/json/` using the `loadJson` function.

### `experiment.coffee` walkthrough

In the first few lines there are some variables and functions initialised and set to `undefined` because they will be defined later on but we want them to be global.

There are some parts of the file that you will probably never need to change. For example, the function `saveData` is there for saving the data to the psiturk server. The function `createStartButton` is there to hide the loader and call the main function `initializeExperiment`. There is also an event handler that's triggered when the window is loaded (`$(window).on load`). There we initialise the data and the functions for later usage. We load the structure and trials from json files.

#### `initializeExperiment`
Firstly we call the function `console.log`. This will print a message to the console. You can see that console in developer tools of your browser when on this experiment's webpage (F12 in Chrome). Writing messages is useful for debugging and testing. Use it:
- when you want to be informed that something is happening
- when you want to see that something was performed successfully, or
- when you want to see that an error occured.

In fact, sometimes the browser will notify you about some errors. So, when something isn't working be sure to firstly take a look at the console and see if there are any problems. That can help with finding the cause. But this is only for the errors that happen on the client side (in the code that's executed in the browser, i.e. in the JavaScript code). Anything that goes bad on the server side (in the Python code) will not be described here in detail, unless you implement additional error handling.

Then we have the block classes. The first class is describing the basic functionality of every block and the others are building on top of that (extending it). You probably won't be changing these either.

Then we define several blocks that we will later add to the timeline of the experiment. Each block has a type (text, mouselab-mdp, survey-text...). Depending on the type, the block has different additional parameters.

The first block is stored in the variable `welcome`. Its type is text so we further specify the text we want to display. The text is a string but we can use HTML in it. The three quotation marks are used for multi-line strings. This is helpful for code readability. Browsers ignore indentation, newlines and multiple whitespaces in HTML code.

Then there is the `finish` block where we display the thank you text and the bonus. 
It also contains a set of questions you might want to ask the participants at the end of the experiment. Of course, any questions block can be inserted elsewhere in the timeline between the trial blocks.

Then there is an example trial block. This block is similar to those in the json files. Note that this block isn't using the structure from `static/json/structure/312.json`. Instead we define a custom structure in code as well. There isn't much difference between specifying blocks inside the `experiment.coffee` code and in a json that you load (other than readability). The block has all the mandatory parameters for the mouselab-mdp type and some optional ones that are used often. What they are used for you can read in the comments along that code.

Finally, we add our blocks to the list `experiment_timeline`. The timeline will look different depending on the value of CONDITION variable.

If DEBUG is set to true the app will show you a prompt where you can type in how many blocks you want to skip. This is useful for testing. If you are content with the first 4 blocks and are working on the fifth block you don't want to go through all 4 of them to see if the fifth is behaving as you want. So you just type _4_ and you can test the fifth block immediately.

#### `jsPsych.init`
This block is necessary for the experiment to work. Currently, the data is displayed in the browser after the experiment instead of being saved. Saving the data would be performed in the `on_finish` function. The code in the `on_data_update` function the data is logged in the console so we can test everything is updated properly after each block.

### JSONs

The trial data is organized in json files. In `static/json/structure` there are several files describing the structure of a trial. In this demo we've only used `312.json`. The trials with optimal feedback are in `static/json/mcrl_trials/increasing.json` and  `static/json/mcrl_trials/increasing_inner_revealed.json`. The trials with action feedback are in `static/json/demo/312_action.json`. The trials with inner nodes (immediate awards) revealed but without feeedback are in `static/json/demo/312_inner_revealed.json`.

## Issues
If you run psiturk and it says that the server is _blocked_ (instead of _off_) you won't be able to run `server on` because another process is using the port which you have in your config. This might happen when you close your console window without turning the server off or if you choose a port in your config that's already in use. If the latter is the case, change the port in the config. If the former is the case, run `lsof -i4 | grep [port]` in the console. You should see the process(es) that are using that port. The first column will say that it's a Python process. Copy the number from the second column (of any of those processes) and run `kill [process-id]`. Then rerun psiturk and the server should be off.
