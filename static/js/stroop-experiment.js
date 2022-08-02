let DEBUG = true;

let NUM_TRIALS = 30;

let getStroopTrials = void 0;

jsPsych = initJsPsych({
  display_element: 'jspsych-target',
  on_finish: function() {
    if (DEBUG) {
      return jsPsych.data.displayData();
    }
  }
});

$(window).on('beforeunload', function() {
  return 'Are you sure you want to leave?';
});

$(window).resize(function() {
  return checkWindowSize(800, 600, $('#jspsych-target'));
});

$(window).resize();

$(window).on('load', function() {
  var loadTimeout, slowLoad;
  // Load data and test connection to server.
  slowLoad = function() {
    var ref;
    return (ref = $('slow-load')) != null ? ref.show() : void 0;
  };
  loadTimeout = delay(12000, slowLoad);

  return delay(300, function() {
    getStroopTrials = function(numCongruent, numIncongruent, numUnrelated){
      let unrelatedWords = ["SHIP", "FORK", "BRIDGE", "MONKEY", "BRAIN", "STONE", "CHAIR", "BOAT", "WINDOW", "BOTTLE", "DOG"]
      let colorWords = ["red","blue","green", "yellow"]
      let trials = [];
      for(let i = 0; i < numCongruent; i++){
        let color = _.sample(colorWords);
        let className = 'stroop-'+color;
        let stimText = `<p id='stroop-text' class='${className}'>${color.toUpperCase()}</p>`;
        let data = {
          "stimulus-type" : "congruent",
          "word" : color,
          "color": color,
          "correct_response" : color[0].toLowerCase()
        }
        trials.push({
          stimulus: stimText,
          data: data
        })
      }
      for(let i = 0; i < numIncongruent; i++){
        let colorName = _.sample(colorWords);
        let remainingColors = colorWords.slice();
        remainingColors.splice(remainingColors.indexOf(colorName),1);
        let color = _.sample(remainingColors);
        let className = 'stroop-'+color;
        let stimText = `<p id='stroop-text' class='${className}'>${colorName.toUpperCase()}</p>`;
        let data = {
          "stimulus-type" : "incongruent",
          "word" : colorName,
          "color": color,
          "correct_response" : color[0].toLowerCase()
        }
        trials.push({
          stimulus: stimText,
          data: data
        })
      }
      for(let i = 0; i < numUnrelated; i++){
        let randomWord = _.sample(unrelatedWords);
        let color = _.sample(colorWords);
        let className = 'stroop-'+color;
        let stimText = `<p id='stroop-text' class='${className}'>${randomWord.toUpperCase()}</p>`;
        let data = {
          "stimulus-type" : "unrelated",
          "word" : randomWord,
          "color": color,
          "correct_response" : color[0].toLowerCase()
        }
        trials.push({
          stimulus: stimText,
          data: data
        })
      }
      return _.shuffle(trials);
    }

    createStartButton();
    return clearTimeout(loadTimeout);
  });
});

createStartButton = function() {
  initializeExperiment();
};

initializeExperiment = function() {

  $('#jspsych-target').html('');
  //  ============================== #
  //  ========= EXPERIMENT ========= #
  //  ============================== #


  let color_game_instructions = {
    type: jsPsychInstructions,
    show_clickable_nav: true,
    pages: function() {
      return [
        `<h1> Instructions for Color-Word Game</h1>

In this game, you will be shown a word on the screen whose letters have a certain color.

<br><br>

Your task is simply to <strong>report the color of the text as fast as possible</strong>. The color of the text can be one of <span style="color:red; font-weight:bold">red</span>, <span style="color:blue; font-weight:bold">blue</span>, <span style="color:green; font-weight:bold">green</span> or <span style="color:yellow; font-weight:bold; text-shadow: 0.07em 0 black, 0 0.07em black, -0.07em 0 black, 0 -0.07em black;">yellow</span>. Accordingly, you must press the corresponding key to report the color you see:
<br> <br>
<ul style="list-style:none">
    <li><code>R</code> - respond with color <span style="color:red; font-weight:bold">RED</span></li>
    <li><code>B</code> - respond with color <span style="color:blue; font-weight:bold">BLUE</span></li>
    <li><code>G</code> - respond with color <span style="color:green; font-weight:bold">GREEN</span></li>
    <li><code>Y</code> - respond with color <span style="color:yellow; font-weight:bold; text-shadow: 0.07em 0 black, 0 0.07em black, -0.07em 0 black, 0 -0.07em black;">YELLOW</span></li>
</ul>
<br>
Examples:
<ul style="list-style:none">
    <li><span style="color:red; font-weight:bold">BLUE</span> - correct answer is <code>R</code></li>
    <li><span style="color:green; font-weight:bold">GREEN</span> - correct answer is <code>G</code></li>
    <li><span style="color:blue; font-weight:bold">SHORT</span> - correct answer is <code>B</code></li>
</ul>
<br><br>
Click 'Next' when you are ready to start!
`
      ];
    }
  };
  let color_game_ready = {
    type: jsPsychHtmlKeyboardResponse,
    choices: [" "],
    stimulus: `<h1> Get ready to start the game! </h1>

Thank you for reading the instructions.

<br><br>
You will complete ${NUM_TRIALS} rounds of this game before moving on to the next game.
<br><br>
Remember, the better you perform, the bigger your bonus will be!
<br><br>
<div style='text-align: center;'>Press <code>space</code> to begin.</div>`
  };
  let finish_distractor = {
    type: jsPsychInstructions,
    show_clickable_nav: true,
    pages: function() {
      return [
        `<h1> End of First Set of Color-Word Game </h1>

Congratulations on making it to the end of the Color-Word game!

We will now begin with the next game, <em>Web of Cash</em>.

Click 'Next' when you are ready to proceed to the instructions of the next game.
`
      ];
    }
  };

  let stroop_trials = {
    on_timeline_start: function() {
      $('body').css('background-color', 'black');
      $('body').append("<p id='correct' class='stroop-correct'>CORRECT</p>")
      $('body').append("<p id='wrong' class='stroop-wrong'>INCORRECT</p>")
    },
    on_timeline_finish: function() {
      $('body').css('background-color', 'white');
      $('#correct').remove()
      $('#wrong').remove()
    },
    on_load: function() {
      $('#stroop-text').show()
      $('#correct').hide()
      $('#wrong').hide()
    },
    post_trial_gap: 500,
    type: jsPsychHtmlKeyboardResponse,
    choices: ["r", "g", "b", "y"],
    timeline: getStroopTrials(NUM_TRIALS/3, NUM_TRIALS/3, NUM_TRIALS/3),
    css_classes: ['stroop-trial'],
    on_finish: function(data){
      $('#stroop-text').hide();
      console.log(data);
      if(data.response.toLowerCase() === data.correct_response.toLowerCase()){
        $('#correct').show();
      } else {
        $('#wrong').show();
      }

    }
  };
  // ================================================ #
  // ========= TIMELINE LOGIC ======================= #
  // ================================================ #



  let experiment_timeline = [color_game_instructions, color_game_ready, stroop_trials, finish_distractor];


  // ================================================ #
  // ========= START AND END THE EXPERIMENT ========= #
  // ================================================ #


  // initialize jspsych experiment -- without this nothing happens
  return jsPsych.run(experiment_timeline);
};
