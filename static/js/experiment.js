// Generated by CoffeeScript 2.7.0
  // coffeelint: disable=max_line_length, indentation
var BLOCKS, BONUS, BONUS_RATE, CONDITION, COST, COST_ANSWERS, COST_CORRECT, COST_EXPLANATION, COST_FORMATTED, COST_QUESTION, DEBUG, DEBUG_SUBMIT, MAX_AMOUNT, MAX_REPETITIONS, NUM_DISTRACTOR_TRIALS, NUM_DISTRACTOR_TRIALS_1, NUM_DISTRACTOR_TRIALS_2, NUM_MDP_TRIALS, NUM_TEST_TRIALS, NUM_TRIALS, NUM_TUTORIAL_TRIALS, NUM_UNREWARDED_TRIALS, N_TRIAL, PARAMS, QUESTIONNAIRES, REPETITIONS, REWARDED_PROP, REWARDED_PROPORTIONS, SCORE, STRUCTURE, TALK, TRIALS, bonus_text, calculateBonus, colorInterpolation, createQuestionnaires, createStartButton, distTrialCount1, distTrialCount2, early_nodes, final_nodes, getClickCosts, getColor, getCost, getDistractorTrials, getRevealedTrials, getScarcityTrials, getTrials, initializeExperiment, jsPsych, psiturk, saveData, trialCount,
  modulo = function(a, b) { return (+a % (b = +b) + b) % b; };

DEBUG = true;

DEBUG_SUBMIT = false;

TALK = false;

if (DEBUG) {
  console.log(`X X X X X X X X X X X X X X X X X
 X X X X X DEBUG  MODE X X X X X
X X X X X X X X X X X X X X X X X`);
  CONDITION = parseInt(condition);
  console.log(condition);
  CONDITION = 5;
} else {
  console.log(`# =============================== #
# ========= NORMAL MODE ========= #
# =============================== #`);
  console.log('16/01/18 12:38:03 PM');
  CONDITION = parseInt(condition);
}

if (mode === "{{ mode }}") {
  CONDITION = 0;
}

REWARDED_PROPORTIONS = [1, 0.9, 0.8, 0.7, 0.6, 0.5];

REWARDED_PROP = REWARDED_PROPORTIONS[CONDITION];

COST = REWARDED_PROP;

COST_FORMATTED = COST.toFixed(2);

COST_ANSWERS = ["There is no cost for clicking on nodes.", "Yes, but the cost for clicking on nodes varies.", `No, the cost is always $${COST_FORMATTED}.`, "It is more costly to inspect 'sticky' nodes."];

COST_QUESTION = "Does the cost of clicking on a node to find out its value vary between nodes?";

COST_CORRECT = "No, the cost is always $1.00.";

// DEPTH = [5,40,80][CONDITION]
REPETITIONS = 0; //tracks trials in instructions quiz

MAX_REPETITIONS = 4; //max tries they get at instructions quiz

BONUS = 0;

QUESTIONNAIRES = void 0;

BLOCKS = void 0;

PARAMS = void 0;

COST_EXPLANATION = void 0;

TRIALS = void 0;

STRUCTURE = void 0;

N_TRIAL = void 0;

SCORE = [0, 0, 0, 0, 0, 0][CONDITION];

BONUS_RATE = .002;

if (DEBUG) {
  NUM_TEST_TRIALS = 5;
} else {
  NUM_TEST_TRIALS = 30;
}

NUM_TRIALS = Math.ceil(NUM_TEST_TRIALS / REWARDED_PROPORTIONS[REWARDED_PROPORTIONS.length - 1]);

NUM_MDP_TRIALS = Math.ceil(NUM_TEST_TRIALS / REWARDED_PROP);

NUM_UNREWARDED_TRIALS = NUM_MDP_TRIALS - NUM_TEST_TRIALS;

NUM_DISTRACTOR_TRIALS = NUM_TRIALS - NUM_MDP_TRIALS;

NUM_DISTRACTOR_TRIALS_1 = Math.floor(NUM_DISTRACTOR_TRIALS / 2);

NUM_DISTRACTOR_TRIALS_2 = Math.ceil(NUM_DISTRACTOR_TRIALS / 2);

NUM_TUTORIAL_TRIALS = 3;

MAX_AMOUNT = BONUS_RATE * (NUM_TRIALS * (4 + 8 + 48) + 800);

trialCount = 0;

distTrialCount1 = 0;

distTrialCount2 = 0;

calculateBonus = void 0;

getCost = void 0;

getColor = void 0;

colorInterpolation = void 0;

getClickCosts = void 0;

getTrials = void 0;

getScarcityTrials = void 0;

getDistractorTrials = void 0;

getRevealedTrials = void 0;

createQuestionnaires = void 0;

bonus_text = void 0;

early_nodes = void 0;

final_nodes = void 0;

jsPsych = initJsPsych({
  display_element: 'jspsych-target',
  on_finish: function() {
    if (DEBUG && !DEBUG_SUBMIT) {
      return jsPsych.data.displayData();
    } else {
      psiturk.recordUnstructuredData('final_bonus', calculateBonus());
      psiturk.recordUnstructuredData('displayed_bonus', BONUS);
      return save_data();
    }
  },
  on_data_update: function(data) {
    // console.log 'data', data
    psiturk.recordTrialData(data);
    return psiturk.saveData();
  }
});

psiturk = new PsiTurk(uniqueId, adServerLoc, mode);

saveData = function() {
  return new Promise(function(resolve, reject) {
    var timeout;
    timeout = delay(10000, function() {
      return reject('timeout');
    });
    return psiturk.saveData({
      error: function() {
        clearTimeout(timeout);
        console.log('Error saving data!');
        return reject('error');
      },
      success: function() {
        clearTimeout(timeout);
        console.log('Data saved to psiturk server.');
        return resolve();
      }
    });
  });
};

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
  psiturk.preloadImages(['static/images/spider.png', 'static/images/web-of-cash-unrevealed.png', 'static/images/web-of-cash.png', 'static/images/sticky_nodes.png']);
  return delay(300, function() {
    var id;
    console.log('Loading data');
    PARAMS = {
      CODE: ['hedgehog', 'bighorn', 'chinchilla', 'porcupine', 'guanaco', 'walrus', 'dromedary', 'aoudad', 'weasel', 'rooster', 'civet', 'iguana', 'fruitbat', 'reindeer', 'bobcat', 'fieldmouse'][modulo(CONDITION, 16)],
      MIN_TIME: 7,
      inspectCost: COST,
      startTime: Date(Date.now()),
      bonusRate: BONUS_RATE,
      variance: '2_4_24',
      branching: '312'
    };
    COST_EXPLANATION = "Some nodes may require more clicks than others.";
    psiturk.recordUnstructuredData('params', PARAMS);
    if (PARAMS.variance) {
      id = `${PARAMS.branching}_${PARAMS.variance}`;
    } else {
      id = `${PARAMS.branching}`;
    }
    QUESTIONNAIRES = loadJson("static/questionnaires/example.txt");
    STRUCTURE = loadJson(`static/json/structure/${id}.json`);
    TRIALS = loadJson(`static/json/rewards/${id}.json`);
    console.log(`loaded ${TRIALS != null ? TRIALS.length : void 0} trials`);
    getScarcityTrials = function(numRewarded, numUnrewarded) {
      var idx, j, k, len, len1, rewardedTrials, shuffledTrials, trial, trialsJoined, unrewardedTrials;
      console.log("Getting scarcity trials" + numRewarded + " " + numUnrewarded);
      shuffledTrials = _.shuffle(TRIALS);
      console.log("shuffled Trials length: " + shuffledTrials.length);
      rewardedTrials = shuffledTrials.slice(0, numRewarded);
      unrewardedTrials = shuffledTrials.slice(numRewarded, numRewarded + numUnrewarded);
      for (idx = j = 0, len = rewardedTrials.length; j < len; idx = ++j) {
        trial = rewardedTrials[idx];
        trial["withholdReward"] = false;
      }
      for (idx = k = 0, len1 = unrewardedTrials.length; k < len1; idx = ++k) {
        trial = unrewardedTrials[idx];
        trial["withholdReward"] = true;
      }
      trialsJoined = rewardedTrials.concat(unrewardedTrials);
      console.log(trialsJoined.length);
      console.log(trialsJoined[0]);
      return _.shuffle(trialsJoined);
    };
    getDistractorTrials = function(num) {
      // Update this to return stroop trials
      return getTrials(num);
    };
    getTrials = (function() {
      var idx, t;
      t = _.shuffle(TRIALS);
      idx = 0;
      return function(n) {
        idx += n;
        return t.slice(idx - n, idx);
      };
    })();
    getRevealedTrials = function(n, early_type) { //if we had newer jspsych we wouldn't have to do this
      var REVEALED_TRIAL, REVEALED_TRIALS, idx, j, len, t;
      REVEALED_TRIALS = _.map(TRIALS, _.clone);
      for (j = 0, len = REVEALED_TRIALS.length; j < len; j++) {
        REVEALED_TRIAL = REVEALED_TRIALS[j];
        if (!early_type) {
          REVEALED_TRIAL["revealed_states"] = early_nodes;
        } else {
          REVEALED_TRIAL["revealed_states"] = final_nodes;
        }
      }
      t = _.shuffle(REVEALED_TRIALS);
      idx = 0;
      idx += n;
      return t.slice(idx - n, idx);
    };
    if (TALK) {
      createStartButton();
      return clearTimeout(loadTimeout);
    } else {
      return saveData().then(function() {
        clearTimeout(loadTimeout);
        return delay(500, createStartButton());
      }).catch(function() {
        clearTimeout(loadTimeout);
        return $('#data-error').show();
      });
    }
  });
});

createQuestionnaires = function(quest_id, quest_data) {
  var horizontal, length_of_options, questionnaire_trial, sum_fn;
  sum_fn = function(a, b) {
    return a + b.length + 5;
  };
  length_of_options = Math.max(...(quest_data["questions"].map(function(question) {
    return question.labels.reduce(sum_fn, 0);
  })));
  horizontal = length_of_options < 65;
  return questionnaire_trial = {
    type: jsPsychSurveyLikert,
    randomize_question_order: false,
    preamble: quest_data["preamble"],
    questions: quest_data["questions"].map(function(question) {
      return {
        prompt: question.prompt,
        name: question.question_id,
        labels: question.labels,
        required: true
      };
    }),
    data: {
      name: quest_data["name"],
      reverse_coded: quest_data["questions"].map(function(question) {
        return question['reverse_coded'];
      }),
      question_id: quest_data["questions"].map(function(question) {
        return question['question_id'];
      })
    }
  };
};

bonus_text = function(long) {
  var s;
  // if PARAMS.bonusRate isnt .01
  //   throw new Error('Incorrect bonus rate')
  s = "<strong>you will earn 1 cent for every $5 you make in the game.</strong>";
  if (long) {
    s += " For example, if your final score is $1000, you will receive a bonus of $2.";
  }
  return s;
};

createStartButton = function() {
  initializeExperiment();
};

initializeExperiment = function() {
  var additional_base, demographics, dist_1_stimulus, dist_2_stimulus, distractor, experiment_timeline, finish, i, j, k, mouselab_instruct_loop, mouselab_instructions, mouselab_quiz, no_distractor, prompt_resubmit, ref, ref1, reprompt, save_data, secret_code_trial, test;
  $('#jspsych-target').html('');
  //  ============================== #
  //  ========= EXPERIMENT ========= #
  //  ============================== #
  no_distractor = {};
  distractor = {};
  no_distractor["experiment_instructions"] = {
    type: jsPsychInstructions,
    on_start: function() {
      return psiturk.finishInstructions(); //started instructions, so no longer worth keeping in database
    },
    show_clickable_nav: true,
    pages: function() {
      return [
        `<h1> Instructions </h1>

In this HIT, you will play ${NUM_MDP_TRIALS} rounds of the <em>Web of Cash</em> game.
<br> <br>

First you will be given the instructions and answer some questions to check your understanding of the game. The whole HIT will take about 35 minutes.

The better you perform, the higher your bonus will be.
`
      ];
    }
  };
  mouselab_instructions = {
    type: jsPsychInstructions,
    on_start: function() {
      return psiturk.finishInstructions(); //started instructions, so no longer worth keeping in database
    },
    show_clickable_nav: true,
    pages: function() {
      return [
        ` <h1>The Spider Web</h1>

 In the <em>Web of Cash</em> game you will guide a money-loving spider through a spider web. Your goal is to travel from the start of the web to the end of the web in three moves. On your way from start to finish, you will pass through the <em>nodes</em> (gray circles) of the spider web.

 Each of these nodes has a certain value, and the values of the nodes that you pass through from start to finish contribute to your score for that round. Your objective on each round is to get the highest score possible. The cumulative final score over all the rounds will be your final score at the end of the game. The higher your final score at the end of the game the higher your HIT bonus will be.

 You will be able to move the spider with the arrow keys, but only in the direction
 of the arrows between the nodes. The image below shows the shape of all the webs that you will be navigating in when the game starts.

<img class='display' style="width:50%; height:auto" src='static/images/web-of-cash-unrevealed.png'/>
`,
        `<h1> <em>Web of Cash</em> Node Inspector (1/2) </h1>

It's hard to make a good decision when you can't see what you will get!
Fortunately, in the <em>Web of Cash</em> game you will have access to a <strong><em>node inspector</em></strong> which can reveal
the value of a node. To use the node inspector, you must <strong><em>click on a node</em></strong>. The image below illustrates how this works.
<br>
The node inspector always costs $${COST_FORMATTED} to reveal one node. The $${COST_FORMATTED} fee will be instantly deducted from the spider's money (your score) for that round.
<br>
<strong>Note:</strong> you can only use the node inspector when you're on the starting
node. Once you start moving, you can no longer inspect any nodes.

<img class='display' style="width:50%; height:auto" src='static/images/web-of-cash.png'/>

`,
        `<h1> Rewards and Costs (2/2) </h1>
<div style="text-align: left">
<li>Each node of the web either contains a reward of up to <strong><font color='green'>$48</font></strong> or a loss of up to <strong><font color='red'>$-48</font></strong></li>
<li>You can find out about a node's loss or reward by using the node inspector, which costs <strong>$${COST_FORMATTED} per revealed node.</strong></li>
<li>At the end of the round, you will be told what your score for that round is.</li>
<li>But there's a catch! The spider, being very focused on collecting the money, sometimes forgets to count how much money it has collected. If the spider forgets to count on a round, <strong>you will not be told what your score for that round is</strong>. Since the spider collects the money nonetheless, <strong>your score for that round will still contribute to your final score for the game</strong>, when all the collected money is counted at the end.</li>

</div>

`,
        `<h1> Bonus </h1>

The more money the spider gets, the bigger your bonus will be!  Concretely, ${bonus_text('long')}
`,
        `<h1> Additional Information </h1>

<img class='display' style="width:50%; height:auto" src='static/images/web-of-cash.png'/>
<div style="text-align: left">
<li>You will be able to use the node inspector in each round.</li>
<li>You will have to click on the starting node before a round starts.</li>
<li><strong>You must spend <em>at least</em> ${PARAMS.MIN_TIME} seconds on each round.</strong> If you finish a round early, you'll have to wait until ${PARAMS.MIN_TIME} seconds have
    passed (before being able to move on).</li>
<li>For each round of the game, the rewards on the web will be different. So you have to make a new plan every time.</li>
</div>`,
        `<h1> Quiz </h1>

Before you can begin playing the <em>Web of Cash</em>, you <em>must</em> pass the instructions quiz to show
that you understand the rules. If you get any of the questions
incorrect, you will be brought back to the instructions to review and
try the quiz again.

You <em>must</em> pass the quiz in at most <strong>${MAX_REPETITIONS}</strong> attempts to continue to the game. <strong>You have ${MAX_REPETITIONS - REPETITIONS} attempt(s) left.</strong>`
      ];
    }
  };
  distractor["experiment_instructions"] = {
    type: jsPsychInstructions,
    show_clickable_nav: true,
    pages: function() {
      return [
        `<h1> Instructions </h1>

In this HIT, you will play multiple rounds of two different games.

<br><br>
First, you will play ${NUM_DISTRACTOR_TRIALS_1} rounds of the <em>Color Word</em> game. After these, you will play ${NUM_MDP_TRIALS} rounds of the <em>Web of Cash</em> game. Finally, you will play another ${NUM_DISTRACTOR_TRIALS_2} rounds of the same Color Word game.

<br><br>
Before each game, you will be given instructions on how to play the game. You may also have to answer some questions to check your understanding of the game.

<br><br>
The better you perform on these games, the higher your bonus will be. The whole HIT will last around 35 minutes.
`
      ];
    }
  };
  distractor["color_game_instructions"] = {
    type: jsPsychInstructions,
    show_clickable_nav: true,
    pages: function() {
      return [
        `<h1> Instructions for Color-Word Game</h1>

In this game, you will be shown a word on the screen whose letters have a certain color.

<br><br>

Your task is simply to <strong>report the color of the text as fast as possible</strong>.

<br><br>
You will complete ${NUM_DISTRACTOR_TRIALS_1} rounds of this game before moving on to the next game.

<br><br>
Click 'Next' when you are ready to start!
`
      ];
    }
  };
  distractor["color_game_ready"] = {
    type: jsPsychHtmlKeyboardResponse,
    choices: [" "],
    stimulus: `<h1> Get ready to start the game! </h1>

Thank you for reading the instructions.

Remember, the better you perform, the bigger your bonus will be!

<div style='text-align: center;'>Press <code>space</code> to begin.</div>`
  };
  distractor["finish_distractor"] = {
    type: jsPsychInstructions,
    show_clickable_nav: true,
    pages: function() {
      return [
        `<h1> End of First Set of Color-Word Game </h1>

Congratulations on making it to the end of the Color-Word game!

We will now begin with the next game, <em>Web of Cash</em>.

Click 'Continue' when you are ready to proceed to the instructions of the next game.
`
      ];
    }
  };
  distractor["finish_webofcash"] = {
    type: jsPsychInstructions,
    show_clickable_nav: true,
    pages: function() {
      return [
        `<h1> End of First Web of Cash Game </h1>

Congratulations on making it to the end of the Web of Cash game!

We will now begin with the next game, which is another set of rounds of the <em>Color-Word Game</em>.

The instructions will be briefly shown to you again, to remind you of what the game entails.

Click 'Continue' when you are ready to proceed.
`
      ];
    }
  };
  //instructions quiz -- they have limited tries (MAX_REPETITIONS) here
  mouselab_quiz = {
    preamble: function() {
      return `<h1> Quiz </h1>
`;
    },
    type: jsPsychSurveyMultiChoice,
    questions: [
      {
        prompt: "What is the range of node values?",
        options: ['$0 to $50',
      '$-10 to $10',
      '$-48 to $48',
      '$-100 to $100'],
        horizontal: false,
        required: true
      },
      {
        prompt: COST_QUESTION,
        options: COST_ANSWERS,
        horizontal: false,
        required: true
      },
      {
        prompt: "Will you receive a bonus?",
        options: ['No.',
      'I will receive a $1 bonus regardless of my performance.',
      'I will receive a $1 bonus if I perform well, otherwise I will receive no bonus.',
      'The better I perform the higher my bonus will be.'],
        horizontal: false,
        required: true
      },
      {
        prompt: "Will each round be the same?",
        options: ['Yes.',
      'No, the amount of cash at each node of the web may be different each time.',
      'No, the structure of the web will be different each time.'],
        horizontal: false,
        required: true
      },
      {
        prompt: "If a node you want to inspect is 'sticky' what should you do?",
        options: ['Keep clicking for $1 a click, up until the cost is too high.',
      'Click until the node is dark grey and can be inspected for $1.',
      'Find another node to inspect as the node is blocked.'],
        horizontal: false,
        required: true
      },
      {
        prompt: "Which statment is true about 'sticky' nodes?",
        options: ['All sticky nodes can be cleaned by clicking 10 times.',
      'Some nodes are so sticky you can\'t clean them.',
      'The number of clicks needed to clean a sticky node can vary.'],
        horizontal: false,
        required: true
      }
    ],
    data: {
      correct: {
        Q0: '$-48 to $48',
        Q1: COST_CORRECT,
        Q2: 'The better I perform the higher my bonus will be.',
        Q3: 'No, the amount of cash at each node of the web may be different each time.',
        Q4: 'Click until the node is dark grey and can be inspected for $1.',
        Q5: 'The number of clicks needed to clean a sticky node can vary.'
      }
    }
  };
  mouselab_instruct_loop = {
    timeline: [mouselab_instructions, mouselab_quiz],
    conditional_function: function() {
      if (DEBUG) {
        return false;
      } else {
        return true;
      }
    },
    loop_function: function(data) {
      var resp_id, response, responses;
      responses = data.last(1).values()[0].response;
      for (resp_id in responses) {
        response = responses[resp_id];
        if (!(data.last(1).values()[0].correct[resp_id] === response)) {
          REPETITIONS += 1;
          if (REPETITIONS < MAX_REPETITIONS) {
            alert(`You got at least one question wrong. We'll send you back to the instructions and then you can try again. Number of attempts left: ${MAX_REPETITIONS - REPETITIONS}.`);
            return true; // try again
          }
        }
      }
      psiturk.saveData();
      return false;
    }
  };
  additional_base = {
    type: jsPsychHtmlKeyboardResponse,
    choices: [" ", "a"],
    stimulus: `<h1> Get ready to start the game! </h1>

Thank you for reading the instructions.

Remember, the more money the spider gets, the bigger your bonus will be!  Concretely, ${bonus_text('long')}

<div style='text-align: center;'>Press <code>space</code> to begin.</div>`
  };
  no_distractor["final_quiz"] = {
    preamble: function() {
      return `<h1>Quiz</h1>

Based on your performance, you will be awarded a total bonus of <strong>$${calculateBonus().toFixed(2)}</strong>. Please answer the following questions about the task before moving on to the questionnaires.
`;
    },
    type: jsPsychSurveyMultiChoice,
    on_finish: function() {
      return BONUS = calculateBonus().toFixed(2);
    },
    questions: [
      {
        prompt: "What is the range of node values in the first step (closest to the start, in the center)?",
        options: ['$-4 to $4',
      '$-8 to $8',
      '$-48 to $48'],
        required: true
      },
      {
        prompt: "What is the range of node values in the middle?",
        options: ['$-4 to $4',
      '$-8 to $8',
      '$-48 to $48'],
        required: true
      },
      {
        prompt: "What is the range of node values in the last step (furthest from the start, the edges)?",
        options: ['$-4 to $4',
      '$-8 to $8',
      '$-48 to $48'],
        required: true
      },
      {
        prompt: COST_QUESTION,
        options: COST_ANSWERS,
        required: true
      },
      {
        prompt: "How motivated were you to perform the task?",
        options: ["Very unmotivated",
      "Slightly unmotivated",
      "Neither motivated nor unmotivated",
      "Slightly motivated",
      "Very motivated"],
        required: true
      }
    ]
  };
  distractor["final_quiz"] = {
    preamble: function() {
      return `<h1>Quiz</h1>

Based on your performance, you will be awarded a total bonus of <strong>$${calculateBonus().toFixed(2)}</strong>. Please answer the following questions about the task before moving on to the final game.
`;
    },
    type: jsPsychSurveyMultiChoice,
    on_finish: function() {
      return BONUS = calculateBonus().toFixed(2);
    },
    questions: [
      {
        prompt: "What is the range of node values in the first step (closest to the start, in the center)?",
        options: ['$-4 to $4',
      '$-8 to $8',
      '$-48 to $48'],
        required: true
      },
      {
        prompt: "What is the range of node values in the middle?",
        options: ['$-4 to $4',
      '$-8 to $8',
      '$-48 to $48'],
        required: true
      },
      {
        prompt: "What is the range of node values in the last step (furthest from the start, the edges)?",
        options: ['$-4 to $4',
      '$-8 to $8',
      '$-48 to $48'],
        required: true
      },
      {
        prompt: COST_QUESTION,
        options: COST_ANSWERS,
        required: true
      },
      {
        prompt: "How motivated were you to perform the task?",
        options: ["Very unmotivated",
      "Slightly unmotivated",
      "Neither motivated nor unmotivated",
      "Slightly motivated",
      "Very motivated"],
        required: true
      }
    ]
  };
  dist_1_stimulus = [];
  for (i = j = 1, ref = NUM_DISTRACTOR_TRIALS_1 + 1; (1 <= ref ? j < ref : j > ref); i = 1 <= ref ? ++j : --j) {
    console.log(i);
    dist_1_stimulus.push({
      stimulus: `This is distractor trial ${i}/${NUM_DISTRACTOR_TRIALS_1}. Press any key to continue.`
    });
  }
  console.log(dist_1_stimulus);
  dist_2_stimulus = [];
  for (i = k = 1, ref1 = NUM_DISTRACTOR_TRIALS_2 + 1; (1 <= ref1 ? k < ref1 : k > ref1); i = 1 <= ref1 ? ++k : --k) {
    console.log(i);
    dist_2_stimulus.push({
      stimulus: `This is distractor trial ${i}/${NUM_DISTRACTOR_TRIALS_2}. Press any key to continue.`
    });
  }
  console.log(dist_2_stimulus);
  distractor["distractor_trials_1"] = {
    type: jsPsychHtmlKeyboardResponse,
    trialId: `distractor_1_${distTrialCount1}`,
    timeline: dist_1_stimulus,
    on_finish: function() {
      return distTrialCount1 += 1;
    }
  };
  distractor["distractor_trials_2"] = {
    type: jsPsychHtmlKeyboardResponse,
    trialId: `distractor_2_${distTrialCount2}`,
    timeline: dist_2_stimulus,
    on_finish: function() {
      return distTrialCount2 += 1;
    }
  };
  // All scarcity trials
  test = {
    type: jsPsychMouselabMDP,
    // display: $('#jspsych-target')
    graph: STRUCTURE.graph,
    layout: STRUCTURE.layout,
    initial: STRUCTURE.initial,
    num_trials: NUM_MDP_TRIALS,
    stateClickCost: function() {
      return COST;
    },
    stateDisplay: 'click',
    withholdReward: true,
    accumulateReward: true,
    wait_for_click: true,
    minTime: DEBUG != null ? DEBUG : {
      undefined: 7
    },
    stateBorder: function() {
      return "rgb(187,187,187,1)"; //getColor
    },
    playerImage: 'static/images/spider.png',
    // trial_id: jsPsych.timelineVariable('trial_id',true)
    blockName: 'test',
    lowerMessage: `Click on the nodes to reveal their values.<br>
Move with the arrow keys after you are done clicking.`,
    timeline: getScarcityTrials(NUM_TEST_TRIALS, NUM_UNREWARDED_TRIALS),
    trialCount: function() {
      return trialCount;
    },
    on_finish: function() {
      return trialCount += 1;
    }
  };
  console.log("Trials created");
  //final screen if participants didn't pass instructions quiz
  no_distractor["finish_fail"] = {
    type: jsPsychSurveyText,
    preamble: function() {
      return `<h1> You've completed the HIT </h1>

Thanks for participating. Unfortunately we can only allow those who understand the instructions to continue with the HIT.

You will receive only the base pay amount when you submit.

Before you submit the HIT, we are interested in knowing some demographic info, and if possible, what problems you encountered with the instructions/HIT.`;
    },
    questions: [
      {
        prompt: 'Was anything confusing or hard to understand?',
        required: false,
        rows: 10
      },
      {
        prompt: 'What is your age?',
        required: true
      },
      {
        prompt: 'What is your gender?',
        required: true
      },
      {
        prompt: 'Are you colorblind?',
        required: true,
        rows: 2
      },
      {
        prompt: 'Additional comments?',
        required: false,
        rows: 10
      }
    ],
    button_label: 'Continue on to secret code'
  };
  distractor["finish_fail"] = {
    type: jsPsychSurveyText,
    preamble: function() {
      return `<h1> You've completed the HIT </h1>

Thanks for participating. Unfortunately we can only allow those who understand the instructions to continue with the HIT.

You will receive only the base pay amount and the bonus for the first game when you submit.

Before you submit the HIT, we are interested in knowing some demographic info, and if possible, what problems you encountered with the instructions/HIT.`;
    },
    questions: [
      {
        prompt: 'Was anything confusing or hard to understand?',
        required: false,
        rows: 10
      },
      {
        prompt: 'What is your age?',
        required: true
      },
      {
        prompt: 'What is your gender?',
        required: true
      },
      {
        prompt: 'Are you colorblind?',
        required: true,
        rows: 2
      },
      {
        prompt: 'Additional comments?',
        required: false,
        rows: 10
      }
    ],
    button_label: 'Continue on to secret code'
  };
  //final screen, if participants actually participated
  finish = {
    type: jsPsychSurveyText,
    preamble: function() {
      return `<h1> You've completed the HIT </h1>

Thanks for participating. We hope you had fun! Based on your
performance in all the games, you will be awarded a bonus of
<strong>$${BONUS}</strong>.

Please briefly answer the questions below before you submit the HIT.`;
    },
    questions: [
      {
        prompt: 'Was anything confusing or hard to understand?',
        required: false,
        rows: 10
      },
      {
        prompt: "After completing this HIT, did you realize that you had already participated in a Web of Cash HIT before? Don't worry, we won't penalize you based on your response here. We completely understand that it's hard to remember which HITs you have or haven't completed.",
        required: true,
        rows: 5
      },
      {
        prompt: 'Additional comments?',
        required: false,
        rows: 10
      }
    ],
    button_label: 'Continue on to secret code'
  };
  //demographics
  demographics = {
    type: jsPsychSurveyHtmlForm,
    preamble: "<h1>Demographics</h1> <br> Please answer the following questions.",
    html: `<p>
  What is your gender?<br>
  <input required type="radio" name="gender" value="male"> Male<br>
  <input required type="radio" name="gender" value="female"> Female<br>
  <input required type="radio" name="gender" value="other"> Other<br>
</p>
<br>
<p>
  How old are you?<br>
  <input required type="number" name="age">
</p>
<br>
<p>
  Are you colorblind?<br>
  <input required type="radio" name="colorblind" value="0">No<br>
  <input required type="radio" name="colorblind" value="1">Yes<br>
  <input required type="radio" name="colorblind" value="2">Don't know<br>
</p>
<br>
<p>
  Since we are doing science, we would now like to know how much attention/effort you put into the game and any surveys. <br><em>(Please note that, even if you answer \'No effort\', it will not affect your pay in anyway and we will not exclude you from future studies based on this response. It will just enable us to do our data analysis better. <strong> We value your time! </strong>)</em><br>
  <input required type="radio" name="effort" value="0">A lot of effort (e.g. paying full attention throughout, trying to get a high score in the <em> Web of Cash </em>)<br>
  <input required type="radio" name="effort" value="1">Some effort (e.g. mostly paying attention, listening to music or a podcast)<br>
  <input required type="radio" name="effort" value="2">Minimal effort (e.g. watching TV and not always looking at the screen, just trying to get through the <em> Web of Cash </em> trials)<br>
  <input required type="radio" name="effort" value="3">No effort (e.g. randomly clicking)<br>
  <input required type="radio" name="effort" value="4">Unsure<br>
</p>`
  };
  // ================================================ #
  // ========= TIMELINE LOGIC ======================= #
  // ================================================ #

  //if the subject fails the quiz 4 times they are just thanked and must leave
  no_distractor["if_node1"] = {
    timeline: [no_distractor["finish_fail"]],
    conditional_function: function() {
      if (REPETITIONS > MAX_REPETITIONS) {
        return true;
      } else {
        return false;
      }
    }
  };
  distractor["if_node1"] = {
    timeline: [distractor["finish_fail"]],
    conditional_function: function() {
      if (REPETITIONS > MAX_REPETITIONS) {
        return true;
      } else {
        return false;
      }
    }
  };
  // if the subject passes the quiz, they continue and can earn a bonus for their performance
  no_distractor["if_node2"] = {
    timeline: [additional_base, test, no_distractor["final_quiz"], createQuestionnaires("pptlr", QUESTIONNAIRES["pptlr"]), demographics, finish],
    conditional_function: function() {
      if (REPETITIONS > MAX_REPETITIONS || DEBUG) {
        return false;
      } else {
        return true;
      }
    }
  };
  no_distractor["if_node2_debug"] = {
    timeline: [additional_base, test, no_distractor["final_quiz"], finish],
    conditional_function: function() {
      if (REPETITIONS > MAX_REPETITIONS || !DEBUG) {
        return false;
      } else {
        return true;
      }
    }
  };
  distractor["if_node2"] = {
    timeline: [additional_base, test, distractor["final_quiz"], distractor["finish_webofcash"], distractor["color_game_instructions"], distractor["distractor_trials_2"], createQuestionnaires("pptlr", QUESTIONNAIRES["pptlr"]), demographics, finish],
    conditional_function: function() {
      if (REPETITIONS > MAX_REPETITIONS || DEBUG) {
        return false;
      } else {
        return true;
      }
    }
  };
  distractor["if_node2_debug"] = {
    timeline: [additional_base, test, distractor["final_quiz"], distractor["finish_webofcash"], distractor["color_game_instructions"], distractor["distractor_trials_2"], finish],
    conditional_function: function() {
      if (REPETITIONS > MAX_REPETITIONS || !DEBUG) {
        return false;
      } else {
        return true;
      }
    }
  };
  // experiment timeline up until now (conditional function properties of nodes keep if_node1 and if_node2 working as we want them)
  experiment_timeline = void 0;
  if (NUM_DISTRACTOR_TRIALS > 0) {
    experiment_timeline = [distractor["experiment_instructions"], distractor["color_game_instructions"], distractor["distractor_trials_1"], distractor["finish_distractor"], mouselab_instruct_loop, distractor["if_node1"], distractor["if_node2"], distractor["if_node2_debug"]];
  } else {
    experiment_timeline = [no_distractor["experiment_instructions"], mouselab_instruct_loop, no_distractor["if_node1"], no_distractor["if_node2"], no_distractor["if_node2_debug"]];
  }
  console.log("Experiment timeline exists: " + !!experiment_timeline);
  // ================================================ #
  // ========= START AND END THE EXPERIMENT ========= #
  // ================================================ #

  // experiment goes to full screen at start
  experiment_timeline.unshift({
    type: jsPsychFullscreen,
    message: '<p>The experiment will switch to full screen mode when you press the button below.<br> Please do not leave full screen for the duration of the experiment. </p>',
    button_label: 'Continue',
    fullscreen_mode: true,
    delay_after: 1000
  });
  // at end, show the secret code and then leave fullscreen
  secret_code_trial = {
    type: jsPsychHtmlButtonResponse,
    choices: ['Finish HIT'],
    stimulus: function() {
      return "The secret code is <strong>" + PARAMS.CODE.toUpperCase() + "</strong>. Please press the 'Finish HIT' button once you've copied it down to paste in the original window.";
    }
  };
  experiment_timeline.push(secret_code_trial);
  experiment_timeline.push({
    type: jsPsychFullscreen,
    fullscreen_mode: false,
    delay_after: 1000
  });
  // bonus is the (roughly) total score multiplied by something, bounded by min and max amount
  calculateBonus = function() {
    var bonus;
    bonus = SCORE * PARAMS.bonusRate;
    bonus = (Math.round(bonus * 100)) / 100; // round to nearest cent
    return Math.min(Math.max(0, bonus), MAX_AMOUNT);
  };
  //saving, finishing functions
  reprompt = null;
  save_data = function() {
    return psiturk.saveData({
      success: async function() {
        console.log('Data saved to psiturk server.');
        if (reprompt != null) {
          window.clearInterval(reprompt);
        }
        await completeExperiment(uniqueId); // Encountering an error here? Try to use Coffeescript 2.0 to compile.
        psiturk.completeHIT();
        return psiturk.computeBonus('compute_bonus');
      },
      error: function() {
        return prompt_resubmit;
      }
    });
  };
  prompt_resubmit = function() {
    $('#jspsych-target').html(`<h1>Oops!</h1>
<p>
Something went wrong submitting your HIT.
This might happen if you lose your internet connection.
Press the button to resubmit.
</p>
<button id="resubmit">Resubmit</button>`);
    return $('#resubmit').click(function() {
      $('#jspsych-target').html('Trying to resubmit...');
      reprompt = window.setTimeout(prompt_resubmit, 10000);
      return save_data();
    });
  };
  // initialize jspsych experiment -- without this nothing happens
  console.log("Running jsPsych");
  return jsPsych.run(experiment_timeline);
};
