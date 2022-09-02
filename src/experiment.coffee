# coffeelint: disable=max_line_length, indentation

DEBUG = no
DEBUG_SUBMIT = no
TALK = no

if DEBUG
  console.log """
  X X X X X X X X X X X X X X X X X
   X X X X X DEBUG  MODE X X X X X
  X X X X X X X X X X X X X X X X X
  """
  CONDITION = parseInt condition
  console.log condition
  CONDITION = 0

else
  console.log """
  # =============================== #
  # ========= NORMAL MODE ========= #
  # =============================== #
  """
  CONDITION = parseInt condition
  console.log condition
  # mcl_scarcity_length_pilot_v2.1
  CONDITION = 0


if mode is "{{ mode }}"

  CONDITION = 0

# REWARDED_PROPORTIONS = [1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3]
# mcl_scarcity_length_pilot_v2.1
# Length pilot 2.1
REWARDED_PROPORTIONS = [1, 0.25]
REWARDED_PROP = REWARDED_PROPORTIONS[CONDITION]
COST = REWARDED_PROP
COST_FORMATTED = COST.toFixed(2);
COST_ANSWERS = ["There is no cost for clicking on nodes.", "The cost for clicking on nodes varies between nodes.", "The cost is always $#{COST_FORMATTED}.", "It is more costly to inspect further nodes."]
COST_QUESTION = "Which of the following is true about the cost of clicking on nodes?"
COST_CORRECT= "The cost is always $#{COST_FORMATTED}."

# DEPTH = [5,40,80][CONDITION]

REPETITIONS = 0 #tracks trials in instructions quiz
MAX_REPETITIONS = 4 #max tries they get at instructions quiz
BONUS = 0
QUESTIONNAIRES = undefined
BLOCKS = undefined
PARAMS = undefined
COST_EXPLANATION = undefined
TRIALS = undefined
STRUCTURE = undefined
N_TRIAL = undefined
INSTRUCTIONS_FAILED = false
SCORE = [0, 0, 0, 0, 0, 0][CONDITION] #TODO EDIT MAX AMOUNT IF CHANGING THIS -- THIS IS TO MAKE CONDITIONS EQUAL
STROOP_1_SCORE = 0
STROOP_2_SCORE = 0
BONUS_RATE = .002

if DEBUG
  NUM_TEST_TRIALS = 10
else
  # TODO: 30 trials for full experiment
  NUM_TEST_TRIALS = 30
  #NUM_TEST_TRIALS = 2

NUM_TRIALS = Math.ceil NUM_TEST_TRIALS / REWARDED_PROPORTIONS[REWARDED_PROPORTIONS.length - 1]
NUM_MDP_TRIALS = Math.ceil NUM_TEST_TRIALS / REWARDED_PROP
NUM_UNREWARDED_TRIALS = NUM_MDP_TRIALS - NUM_TEST_TRIALS
NUM_DISTRACTOR_TRIALS = NUM_TRIALS - NUM_MDP_TRIALS
NUM_DISTRACTOR_TRIALS_1 = Math.floor NUM_DISTRACTOR_TRIALS / 2
NUM_DISTRACTOR_TRIALS_2 = Math.ceil NUM_DISTRACTOR_TRIALS / 2

# Convert MDP trials to stroop trials
MDP_TO_STROOP_CONVERSION = 10
MAX_MDP_BLOCK_LENGTH = 30
# TODO: 100 trials for full experiment
MAX_STROOP_BLOCK_LENGTH = 100
# MAX_STROOP_BLOCK_LENGTH = 6

if DEBUG
  MAX_STROOP_BLOCK_LENGTH = 10
  MAX_MDP_BLOCK_LENGTH = 5

NUM_MDP_BLOCKS = Math.ceil NUM_MDP_TRIALS / MAX_MDP_BLOCK_LENGTH
MDP_BLOCKS = new Array(NUM_MDP_BLOCKS).fill(Math.floor NUM_MDP_TRIALS / NUM_MDP_BLOCKS)
REMAINDER_TRIALS = NUM_MDP_TRIALS % NUM_MDP_BLOCKS
for i in [0...REMAINDER_TRIALS]
  MDP_BLOCKS[i] += 1

NUM_DISTRACTOR_TRIALS_1 *= MDP_TO_STROOP_CONVERSION
NUM_BLOCKS_1 = Math.ceil NUM_DISTRACTOR_TRIALS_1 / MAX_STROOP_BLOCK_LENGTH
STROOP_BLOCKS_1 = new Array(NUM_BLOCKS_1).fill(Math.ceil NUM_DISTRACTOR_TRIALS_1 / NUM_BLOCKS_1)

NUM_DISTRACTOR_TRIALS_2 *= MDP_TO_STROOP_CONVERSION
NUM_BLOCKS_2 = Math.ceil NUM_DISTRACTOR_TRIALS_2 / MAX_STROOP_BLOCK_LENGTH
STROOP_BLOCKS_2 = new Array(NUM_BLOCKS_2).fill(Math.ceil NUM_DISTRACTOR_TRIALS_2 / NUM_BLOCKS_2)

NUM_TUTORIAL_TRIALS = 2
MAX_AMOUNT = BONUS_RATE*(NUM_TRIALS*(4+8+48)+800)
trialCount = 0
pracTrialCount = 0
distTrialCount1 = 0
distTrialCount2 = 0
calculateBonus = undefined
getCost = undefined
getColor = undefined
colorInterpolation = undefined
getClickCosts = undefined
getTrials = undefined
getScarcityTrials = undefined
getPracticeTrials = undefined
getDistractorTrials = undefined
getRevealedTrials = undefined
createQuestionnaires = undefined
getStroopTrials = undefined
bonus_text = undefined
early_nodes = undefined
final_nodes = undefined

jsPsych = initJsPsych(
    display_element: 'jspsych-target'
    on_finish: ->
      if DEBUG and not DEBUG_SUBMIT
        jsPsych.data.displayData()
      else
        save_data = ->
          psiturk.saveData
            success: ->
              console.log 'Data saved to psiturk server.'
              if reprompt?
                window.clearInterval reprompt
              await completeExperiment uniqueId # Encountering an error here? Try to use Coffeescript 2.0 to compile.
              psiturk.completeHIT();
            error: -> prompt_resubmit

        prompt_resubmit = ->
          $('#jspsych-target').html """
            <h1>Oops!</h1>
            <p>
            Something went wrong submitting your HIT.
            This might happen if you lose your internet connection.
            Press the button to resubmit.
            </p>
            <button id="resubmit">Resubmit</button>
          """
          $('#resubmit').click ->
            $('#jspsych-target').html 'Trying to resubmit...'
            reprompt = window.setTimeout(prompt_resubmit, 10000)
            save_data()

        psiturk.recordUnstructuredData 'final_score', SCORE
        save_data()

    on_data_update: (data) ->
      # console.log 'data', data
      psiturk.recordTrialData data
      psiturk.saveData()
)
psiturk = new PsiTurk uniqueId, adServerLoc, mode
saveData = ->
  new Promise (resolve, reject) ->
    timeout = delay 10000, ->
      reject('timeout')

    psiturk.saveData
      error: ->
        clearTimeout timeout
        console.log 'Error saving data!'
        reject('error')
      success: ->
        clearTimeout timeout
        console.log 'Data saved to psiturk server.'
        resolve()

$(window).on 'beforeunload', -> 'Are you sure you want to leave?';
$(window).resize -> checkWindowSize 800, 600, $('#jspsych-target')
$(window).resize()
$(window).on 'load', ->
  # Load data and test connection to server.
  slowLoad = -> $('slow-load')?.show()
  loadTimeout = delay 12000, slowLoad

  psiturk.preloadImages [
    'static/images/spider.png'
    'static/images/web-of-cash-unrevealed.png'
    'static/images/web-of-cash.png'
    'static/images/sticky_nodes.png'
  ]


  delay 300, ->
    console.log 'Loading data'
    PARAMS =
      CODE : "CD8YV6VN"
      MIN_TIME : 7
      inspectCost: COST
      startTime: Date(Date.now())
      bonusRate: BONUS_RATE
      variance: '2_4_24'
      branching: '312'

    COST_EXPLANATION = "Some nodes may require more clicks than others."

    psiturk.recordUnstructuredData 'params', PARAMS

    if PARAMS.variance
      id = "#{PARAMS.branching}_#{PARAMS.variance}"
    else
      id = "#{PARAMS.branching}"

    QUESTIONNAIRES = loadJson "static/questionnaires/example.txt"

    STRUCTURE = loadJson "static/json/structure/#{id}.json"
    TRIALS = loadJson "static/json/rewards/#{id}.json"
    console.log "loaded #{TRIALS?.length} trials"

    getPracticeTrials = (numTrials) ->
      templateTrial = TRIALS[0]["stateRewards"]
      trials = []
      for i in [0...numTrials]
        trialObj = {}
        trialObj["trial_id"] = "practice_" + (i+1)
        trialObj["stateRewards"] = []
        for reward, idx_2 in templateTrial
          if idx_2 > 0
            trialObj["stateRewards"].push(_.sample([-10.0, 10.0]))
          else
            trialObj["stateRewards"].push(0.0)
        trials.push(trialObj)
      return trials

    getScarcityTrials = (numRewarded, numUnrewarded) ->
      shuffledTrials = _.shuffle TRIALS
      rewardedTrials = shuffledTrials.slice(0, numRewarded)
      unrewardedTrials = shuffledTrials.slice(numRewarded, numRewarded + numUnrewarded)
      for trial, idx in rewardedTrials
        trial["withholdReward"] = false
      for trial, idx in unrewardedTrials
        trial["withholdReward"] = true


      trialsJoined = rewardedTrials.concat(unrewardedTrials)
      for trial, idx in trialsJoined
        trial["trial_id"] = "mdp_" + trial["trial_id"]
      return _.shuffle trialsJoined

    getStroopTrials = (num, id) ->
      numCongruent = 0
      numIncongruent = 0
      numUnrelated = 0
      if num % 3 == 1
        numCongruent = Math.floor(num/3)
        numIncongruent = Math.ceil(num/3)
        numUnrelated = Math.floor(num/3)
      else if num % 3 == 2
        numCongruent = Math.ceil(num/3)
        numIncongruent = Math.ceil(num/3)
        numUnrelated = Math.floor(num/3)
      else
        numCongruent = Math.floor(num/3)
        numIncongruent = Math.floor(num/3)
        numUnrelated = Math.floor(num/3)
      unrelatedWords = ["SHIP", "FORK", "BRIDGE", "MONKEY", "BRAIN", "STONE", "CHAIR", "BOAT", "WINDOW", "BOTTLE", "DOG"]
      colorWords = ["red","blue","green", "yellow"]
      trials = []
      # Congruent trials
      for i in [0...numCongruent]
        color = _.sample(colorWords);
        className = 'stroop-'+color;
        stimText = "<p id='stroop-text' class='#{className}'>#{color.toUpperCase()}</p>";
        data =
          "stimulus-type" : "congruent",
          "word" : color,
          "color": color,
          "correct_response" : color[0].toLowerCase()
          "trial_id" : "stroop-trial-" + id + "-congruent-" + (i+1)
        trial =
          stimulus: stimText,
          data: data
        trials.push trial

      # Incongruent trials
      for i in [0...numIncongruent]
        colorName = _.sample(colorWords);
        remainingColors = colorWords.slice();
        remainingColors.splice(remainingColors.indexOf(colorName),1);
        color = _.sample(remainingColors);
        className = 'stroop-'+color;
        stimText = "<p id='stroop-text' class='#{className}'>#{colorName.toUpperCase()}</p>";
        data =
          "stimulus-type" : "incongruent",
          "word" : colorName,
          "color": color,
          "correct_response" : color[0].toLowerCase()
          "trial_id" : "stroop-trial-" + id + "-incongruent-" + (i+1)
        trial =
          stimulus: stimText,
          data: data
        trials.push trial

      # Unrelated Trials
      for i in [0...numUnrelated]
        randomWord = _.sample(unrelatedWords);
        color = _.sample(colorWords);
        className = 'stroop-'+color;
        stimText = "<p id='stroop-text' class='#{className}'>#{randomWord.toUpperCase()}</p>";
        data =
          "stimulus-type" : "unrelated",
          "word" : randomWord,
          "color": color,
          "correct_response" : color[0].toLowerCase()
          "trial_id" : "stroop-trial-" + id + "-unrelated-" + (i+1)
        trial =
          stimulus: stimText,
          data: data
        trials.push trial

      return _.shuffle trials

    getTrials = do ->
      t = _.shuffle TRIALS
      idx = 0
      return (n) ->
        idx += n
        t.slice(idx-n, idx)

    getRevealedTrials = (n, early_type) -> #if we had newer jspsych we wouldn't have to do this
      REVEALED_TRIALS = _.map(TRIALS, _.clone);
      for REVEALED_TRIAL in REVEALED_TRIALS
        # if (Math.random()<.5)
        if (!early_type)
        then REVEALED_TRIAL["revealed_states"] = early_nodes
        else REVEALED_TRIAL["revealed_states"] = final_nodes
      t = _.shuffle REVEALED_TRIALS
      idx = 0
      idx += n
      t.slice(idx-n, idx)

    if TALK
      createStartButton()
      clearTimeout loadTimeout
    else
      saveData()
        .then ->
          clearTimeout loadTimeout
          delay 500, createStartButton()
        .catch ->
          clearTimeout loadTimeout
          $('#data-error').show()

createQuestionnaires = (quest_id, quest_data) ->
  sum_fn = (a,b) -> a+b.length+5
  length_of_options = Math.max \
                (quest_data["questions"].map (question) -> question.labels.reduce sum_fn, 0)...
  horizontal = (length_of_options<65)

  questionnaire_trial =
    type: jsPsychSurveyLikert
    randomize_question_order: false
    preamble: quest_data["preamble"]
    questions: quest_data["questions"].map (question) -> {prompt: question.prompt, name: question.question_id, labels: question.labels, required:true}
    data:
      name: quest_data["name"]
      reverse_coded: quest_data["questions"].map (question) -> question['reverse_coded']
      question_id: quest_data["questions"].map (question) -> question['question_id']


bonus_text = (long) ->
    # if PARAMS.bonusRate isnt .01
    #   throw new Error('Incorrect bonus rate')
    s = "<strong>you will earn 1 cent for every $5 you make in the game.</strong>"
    if long
      s += " For example, if your final score is $1000, you will receive a bonus of $2."
    return s


createStartButton = ->
  initializeExperiment()
  return


initializeExperiment = ->
  $('#jspsych-target').html ''


  #  ============================== #
  #  ========= EXPERIMENT ========= #
  #  ============================== #

  no_distractor = {}
  distractor = {}

  no_scarce = {}
  scarce = {}

  no_distractor["experiment_instructions"] = {
    type: jsPsychInstructions
    on_start: () ->
      psiturk.finishInstructions() #started instructions, so no longer worth keeping in database
    show_clickable_nav: true
    data:
      trial_id: "exp_instructions_no_distractor"
    pages: -> [
      """
        <h1> Instructions </h1>

        In this HIT, you will play #{NUM_MDP_TRIALS} rounds of the <em>Web of Cash</em> game.
        <br> <br>

        First you will be given the instructions and answer some questions to check your understanding of the game.

        <br><br>
        If you complete the entire experiment, you will receive a bonus payment for your performance in these games. The better you perform, the higher your bonus will be. The whole HIT will last around 40 minutes.

        <br><br>

        <strong>NOTE: </strong> Please complete the experiment within one sitting without closing or refreshing the page. If you do either of these, you will no longer be able to get back into the experiment to complete it.

      """
    ]
  }
  mouselab_instructions_1 = {
    type: jsPsychInstructions
    data:
      trial_id: "mouselab_instructions_1"
    show_clickable_nav: true
    pages: -> [

         """
        <h1>The Spider Web</h1>

        In the <em>Web of Cash</em> game you will guide a money-loving spider through a spider web. Your goal is to travel from the start of the web to the end of the web in three moves.
        <br><br>
        On your way from start to finish, you will pass through the <em>nodes</em> (gray circles) of the spider web.

        Each of these nodes has a certain value, and <strong>the money collected from the nodes that you pass through from start to finish contribute to your score for that round.</strong> Once you finish a round, the score for that round will be displayed.

        <br><br>
        Your objective on each round is to get the highest score possible. The cumulative final score over all the rounds will be your final score at the end of the game. The higher your final score at the end of the game, the higher your HIT bonus will be.
        <br><br>
        You will be able to move the spider with the arrow keys, but only in the direction
        of the arrows between the nodes. The image below shows the shape of all the webs that you will be navigating in when the game starts.

       <img class='display' style="width:50%; height:auto" src='static/images/web-of-cash-unrevealed.png'/>

      """

         """
        <h1> <em>Web of Cash</em> (1/3) - Node Inspector</h1>

        It's hard to make a good decision when you can't see what you will get!
        Fortunately, in the <em>Web of Cash</em> game you will have access to a <strong><em>node inspector</em></strong> which can reveal
        the value of a node. To use the node inspector, you must <strong><em>click on a node</em></strong>. The image below illustrates how this works.
        <br><br>
        The node inspector always costs $#{COST_FORMATTED} to reveal one node. The $#{COST_FORMATTED} fee will be instantly deducted from the spider's money (your score) for that round.
        <br><br>
        <strong>Note:</strong> you can only use the node inspector when you're on the starting
        node. Once you start moving, you can no longer inspect any nodes.

        <img class='display' style="width:50%; height:auto" src='static/images/web-of-cash.png'/>


    """
         """
        <h1> <em>Web of Cash</em> (2/3) - Rewards and Costs </h1>
        <div style="text-align: left">
        <li>You can find out about a node's loss or reward by using the node inspector, which costs <strong>$#{COST_FORMATTED} per revealed node.</strong></li>
        <li>In each round, you can see the score for that round in the top right corner.</li>
        <li>At the end of the round, you will be told what your score for that round is.</li>
        </div>

      """


         """
        <h1> Additional Information </h1>

        <img class='display' style="width:50%; height:auto" src='static/images/web-of-cash.png'/>
        <div style="text-align: left">
        <li>You will be able to use the node inspector in each round.</li>
        <li>You will have to click on the starting node before a round starts.</li>
        </div>
      """
         """
        <h1> Practice Rounds </h1>

        To help you understand the game, it would be helpful to have some practice rounds. The following two rounds will give you a chance to practice playing the game.
        <br> <br>
        However, the practice rounds will differ from the actual rounds of the game in one important respect: the values at the nodes have the same magnitude (either 10 or -10). This will <strong>NOT</strong> be the case in the actual rounds, and <strong>the values of the nodes in the actual game will instead vary between the nodes.</b>
        <br><br>
        The score you receive on these practice rounds will <b>NOT</b> count towards your final score for this game.
        <br><br>
        Click 'Next' to start with the practice rounds.
        """
      ]
    }

    # TODO: Update to wait_for_click: true - pilot v3.1
  practice_trials = {
    type: jsPsychMouselabMDP
# display: $('#jspsych-target')
    graph: STRUCTURE.graph
    layout: STRUCTURE.layout
    initial: STRUCTURE.initial
    num_trials: NUM_TUTORIAL_TRIALS
    stateClickCost: () -> COST
    stateDisplay: 'click'
    accumulateReward: true
    wait_for_click: false
    withholdReward: false
    scoreShift: 2
    stateBorder : () -> "rgb(187,187,187,1)"#getColor
    playerImage: 'static/images/spider.png'
# trial_id: jsPsych.timelineVariable('trial_id',true)
    blockName: 'test'
    upperMessage: "Web of Cash - Practice Round"
    lowerMessage: """
      Click on the nodes to reveal their values.<br>
      Move with the arrow keys after you are done clicking.
        """
    timeline: getPracticeTrials NUM_TUTORIAL_TRIALS
    trialCount: () -> pracTrialCount
    on_finish: () ->
      pracTrialCount += 1
      SCORE = 0
    on_timeline_start: () ->
      pracTrialCount = 0
  }

  scarce["mouselab_instructions_2"] = {
    type: jsPsychInstructions
    data:
      trial_id: "mouselab_instructions_2_scarce"
    show_clickable_nav: true
    pages: -> [

      """
        <h1> <em>Web of Cash</em> (3/3) - Rewards and Costs </h1>
        Now that you understand how the node inspector works from the practice rounds, here is what you need to know about the actual rounds of the game that count:
        <br><br>
        <div style="text-align: left">
        <li>Each node of the web either contains a reward of up to <strong><font color='green'>$48</font></strong> or a loss of up to <strong><font color='red'>$-48</font></strong></li>
        <li>You can find out about a node's loss or reward by using the node inspector, which costs <strong>$#{COST_FORMATTED} per revealed node.</strong></li>
        <li>In each round, you can see the score for that round in the top right corner.</li>
        <li>At the end of each round, you will be told what your score for that round is.</li>
        <li><strong>But there's a catch!</strong> Even though the spider loves money, it is also very forgetful. For this reason, the spider might forget to count the money collected on some rounds. <strong>If the spider forgets to count on a round, you will not know what your score for that round is</strong>.</li>
        <li>At the end of the game, you will be told what your score for the whole game is.</li>
        <li>The higher your score at the end of the game, the bigger your bonus will be!</li>
        </div>

      """

      """
        <h1> Additional Information </h1>

        <img class='display' style="width:50%; height:auto" src='static/images/web-of-cash.png'/>
        <div style="text-align: left">
        <li>You will be able to use the node inspector in each round.</li>
        <li>You will have to click on the starting node before a round starts.</li>
        <li><strong>You must spend <em>at least</em> #{PARAMS.MIN_TIME} seconds on each round.</strong> If you finish a round early, you'll have to wait until #{PARAMS.MIN_TIME} seconds have
            passed (before being able to move on).</li>
        <li>For each round of the game, the rewards on the web will be different. So you have to make a new plan every time.</li>
        </div>
      """
      """
        <h1> Quiz </h1>

        Before you can begin playing the <em>Web of Cash</em>, you <em>must</em> pass the instructions quiz to show
        that you understand the rules. If you get any of the questions
        incorrect, you will be brought back to the instructions to review and
        try the quiz again.

        You <em>must</em> pass the quiz in at most <strong>#{MAX_REPETITIONS}</strong> attempts to continue to the game. <strong>You have #{MAX_REPETITIONS-REPETITIONS} attempt(s) left.</strong>
        """
    ]
  }

  no_scarce["mouselab_instructions_2"] = {
    type: jsPsychInstructions
    data:
      trial_id: "mouselab_instructions_2_noscarce"
    on_start: () ->
    show_clickable_nav: true
    pages: -> [

      """
        <h1> <em>Web of Cash</em> (3/3) - Rewards and Costs </h1>
        Now that you understand how the node inspector works from the practice rounds, here is what you need to know about the actual rounds of the game that count:
        <br><br>
        <div style="text-align: left">
        <li>Each node of the web either contains a reward of up to <strong><font color='green'>$48</font></strong> or a loss of up to <strong><font color='red'>$-48</font></strong></li>
        <li>You can find out about a node's loss or reward by using the node inspector, which costs <strong>$#{COST_FORMATTED} per revealed node.</strong></li>
        <li>In each round, you can see the score for that round in the top right corner.</li>
        <li>At the end of each round, you will be told what your score for that round is.</li>
        <li>At the end of the game, you will be told what your score for the whole game is.</li>
        <li>The higher your score at the end of the game, the bigger your bonus will be!</li>
        </div>

      """

      """
        <h1> Additional Information </h1>

        <img class='display' style="width:50%; height:auto" src='static/images/web-of-cash.png'/>
        <div style="text-align: left">
        <li>You will be able to use the node inspector in each round.</li>
        <li>You will have to click on the starting node before a round starts.</li>
        <li><strong>You must spend <em>at least</em> #{PARAMS.MIN_TIME} seconds on each round.</strong> If you finish a round early, you'll have to wait until #{PARAMS.MIN_TIME} seconds have
            passed (before being able to move on).</li>
        <li>For each round of the game, the rewards on the web will be different. So you have to make a new plan every time.</li>
        </div>
      """
      """
        <h1> Quiz </h1>

        Before you can begin playing the <em>Web of Cash</em>, you <em>must</em> pass the instructions quiz to show
        that you understand the rules. If you get any of the questions
        incorrect, you will be brought back to the instructions to review and
        try the quiz again.

        You <em>must</em> pass the quiz in at most <strong>#{MAX_REPETITIONS}</strong> attempts to continue to the game. <strong>You have #{MAX_REPETITIONS-REPETITIONS} attempt(s) left.</strong>
        """
    ]
  }

  distractor["experiment_instructions"] = {
    type: jsPsychInstructions
    data:
      trial_id: "exp_instructions_distractor"
    on_start: () ->
      psiturk.finishInstructions() #started instructions, so no longer worth keeping in database
    show_clickable_nav: true
    pages: -> [
      """
        <h1> Instructions </h1>

        In this HIT, you will play multiple rounds of two different games.

        <br><br>
        First, you will play #{NUM_DISTRACTOR_TRIALS_1} rounds of the <em>Color Word</em> game. After these, you will play #{NUM_MDP_TRIALS} rounds of the <em>Web of Cash</em> game. Finally, you will play another #{NUM_DISTRACTOR_TRIALS_2} rounds of the same <em>Color Word</em> game.

        <br><br>
        Before each game, you will be given instructions on how to play the game. You may also have to answer some questions to check your understanding of the game.

        <br><br>
        If you complete the entire experiment, you will receive a bonus payment for your performance in these games. The better you perform, the higher your bonus will be. The whole HIT will last around 40 minutes.

        <br><br>
        <strong>NOTE: </strong> Please complete the experiment within one sitting without closing or refreshing the page. If you do either of these, you will no longer be able to get back into the experiment to complete it.
      """
    ]
  }

  distractor["color_game_instructions"] = {
    type: jsPsychInstructions
    data:
      trial_id: "color_game_instructions"
    show_clickable_nav: true
    pages: -> [
      """
        <h1> Instructions for Color-Word Game</h1>

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

      """
    ]
  }

  # Stroop block structure of first set of distractor trials
  distractor["distractor_1_timeline"] = []
  for numBlockTrials, idx in STROOP_BLOCKS_1
    ready_screen = undefined
    if idx == 0
      ready_screen =
        type: jsPsychHtmlKeyboardResponse
        data:
          trial_id: "stroop_1_ready_" + (idx+1)
        choices: [" "]
        stimulus: """
          <h1> Get ready to start the game! </h1>

          Thank you for reading the instructions. Get ready start with the first of #{STROOP_BLOCKS_1.length} block(s) of this game.
          <br><br>
          In this first block, you will complete #{numBlockTrials} rounds of this game before moving on.
          <br><br>
          Remember, the better you perform, the bigger your bonus will be!
          <br><br>
          <div style='text-align: center;'>Press <code>space</code> to begin.</div>
        """
    else
      ready_screen =
        type: jsPsychHtmlKeyboardResponse
        data:
          trial_id: "stroop_1_ready_" + (idx+1)
        choices: [" "]
        stimulus: """
          <h1> End of block! </h1>

          You have reached the end of the block #{idx}/#{STROOP_BLOCKS_1.length}. If you need a short break, feel free to take one now before moving on.

          <br><br>
          In the next block, you will complete another #{numBlockTrials} rounds of this game.

          <br><br>
          <div style='text-align: center;'>Press <code>space</code> to begin.</div>
          <br><br>
        <div style='text-align: center;'>(If the experiment doesn't continue, try clicking on the text and then pressing <code>space</code>.)</div>
        """

    distractor["distractor_1_timeline"].push ready_screen
    stroop_trials =
      type: jsPsychHtmlKeyboardResponse,
      on_timeline_start: ->
        $('body').css('background-color', 'black')
        $('body').append("<p id='correct' class='stroop-correct'>CORRECT</p>")
        $('body').append("<p id='wrong' class='stroop-wrong'>INCORRECT</p>")
      on_timeline_finish: ->
        $('body').css('background-color', 'white')
        $('#correct').remove()
        $('#wrong').remove()
      on_load: ->
        $('#stroop-text').show()
        $('#correct').hide()
        $('#wrong').hide()
      post_trial_gap: 500
      choices: ["r", "g", "b", "y"]
      timeline: getStroopTrials numBlockTrials, 1
      css_classes: ['stroop-trial']
      on_finish: (data) ->
        $('#stroop-text').hide()
        if data.response.toLowerCase() == data.correct_response.toLowerCase()
          $('#correct').show()
          STROOP_1_SCORE += 1;
        else
          $('#wrong').show()

    distractor["distractor_1_timeline"].push stroop_trials

  # Stroop block structure of second set of distractor trials
  distractor["distractor_2_timeline"] = []
  for numBlockTrials, idx in STROOP_BLOCKS_2
    ready_screen = undefined
    if idx == 0
      ready_screen =
        type: jsPsychHtmlKeyboardResponse
        data:
          trial_id: "stroop_2_ready_" + (idx+1)
        choices: [" "]
        stimulus: """
          <h1> Get ready to start the game! </h1>

          Thank you for reading the instructions. Get ready start with the first of #{STROOP_BLOCKS_2.length} block(s) of this game.
          <br><br>
          In this first block, you will complete #{numBlockTrials} rounds of this game before moving on.
          <br><br>
          Remember, the better you perform, the bigger your bonus will be!
          <br><br>
          <div style='text-align: center;'>Press <code>space</code> to begin.</div>
        """
    else
      ready_screen =
        type: jsPsychHtmlKeyboardResponse
        choices: [" "]
        data:
          trial_id: "stroop_2_ready_" + (idx+1)
        stimulus: """
          <h1> End of block! </h1>

          You have reached the end of the block #{idx}/#{STROOP_BLOCKS_2.length}. If you need a short break, feel free to take one now before moving on.

          <br><br>
          In the next block, you will complete another #{numBlockTrials} rounds of this game.

          <br><br>
          <div style='text-align: center;'>Press <code>space</code> to begin.</div>
          <br><br>
<div style='text-align: center;'>(If the experiment doesn't continue, try clicking on the text and then pressing <code>space</code>.)</div>
        """

    distractor["distractor_2_timeline"].push ready_screen
    stroop_trials =
      type: jsPsychHtmlKeyboardResponse,
      on_timeline_start: ->
        $('body').css('background-color', 'black')
        $('body').append("<p id='correct' class='stroop-correct'>CORRECT</p>")
        $('body').append("<p id='wrong' class='stroop-wrong'>INCORRECT</p>")
      on_timeline_finish: ->
        $('body').css('background-color', 'white')
        $('#correct').remove()
        $('#wrong').remove()
      on_load: ->
        $('#stroop-text').show()
        $('#correct').hide()
        $('#wrong').hide()
      post_trial_gap: 500
      choices: ["r", "g", "b", "y"]
      timeline: getStroopTrials numBlockTrials, 2
      css_classes: ['stroop-trial']
      on_finish: (data) ->
        $('#stroop-text').hide()
        if data.response.toLowerCase() == data.correct_response.toLowerCase()
          $('#correct').show()
          STROOP_2_SCORE += 1;
        else
          $('#wrong').show()
    distractor["distractor_2_timeline"].push stroop_trials


  distractor["finish_distractor"] = {
    type: jsPsychInstructions
    data:
      trial_id: "finish_distractor_1"
    show_clickable_nav: true
    pages: -> [
      """
        <h1> End of First Set of Color-Word Game </h1>

        Congratulations on making it to the end of the Color-Word game! Your score for all the rounds of the game was <strong>#{STROOP_1_SCORE}/#{NUM_DISTRACTOR_TRIALS_1}</strong>.
        <br> <br>
        We will now begin with the next game, <em>Web of Cash</em>. If you would like to take a short break, you may take one now and continue to the next game when you are ready.
        <br> <br>
        Click 'Next' when you are ready to proceed to the instructions of the next game.

      """
    ]
  }

  distractor["finish_distractor_2"] = {
    type: jsPsychInstructions
    data:
      trial_id: "finish_distractor_2"
    show_clickable_nav: true
    pages: -> [
      """
        <h1> End of Second Set of Color-Word Game </h1>

        Congratulations on making it to the end of the Color-Word game! Your score for all the rounds of the game was <strong>#{STROOP_2_SCORE}/#{NUM_DISTRACTOR_TRIALS_2}</strong>.
        <br> <br>
        With that, you have come to the end of the experiment!
        <br> <br>
        Click 'Next' to continue to the end of the HIT.

      """
    ]
  }
  distractor["finish_webofcash"] = {
    type: jsPsychInstructions
    data:
      trial_id: "finish_web_of_cash"
    show_clickable_nav: true
    pages: -> [
      """
        <h1> End of Web of Cash Game </h1>

        Congratulations on making it to the end of the Web of Cash game!
        <br> <br>

        We will now begin with the next game, which is another set of rounds of the <em>Color-Word Game</em>. If you would like to take a short break, you may take one now and continue to the next game when you are ready.
        <br><br>
        The instructions will be briefly shown to you again, to remind you of what the game entails.
        <br><br>
        Click 'Next' when you are ready to proceed.

      """
    ]
  }


  #instructions quiz -- they have limited tries (MAX_REPETITIONS) here
  scarce["mouselab_quiz"] = {
    preamble: ->  """
      <h1> Quiz </h1>

    """
    type: jsPsychSurveyMultiChoice
    questions: [
      {prompt: "What is the range of node values in the actual game?", options: ['$0 to $50', '$-10 to $10', '$-48 to $48', '$-100 to $100'], horizontal: false, required: true}
      {prompt: COST_QUESTION, options: COST_ANSWERS ,  horizontal: false, required: true}
      {prompt: "Will you receive a bonus?", options: ['No.', 'I will receive a $1 bonus regardless of my performance.', 'I will receive a $1 bonus if I perform well, otherwise I will receive no bonus.', 'The better I perform the higher my bonus will be.'],  horizontal: false, required: true}
      {prompt: "Will each round be the same?", options: ['Yes.','No, the amount of cash at each node of the web may be different each time.', 'No, the structure of the web will be different each time.'],  horizontal: false, required: true}
      {prompt: "What determines your score for a round?", options: ["The values of the nodes walked through from start to finish.", "The score for a round is random.", "How much time it takes to complete a round."],  horizontal: false, required: true}
      {prompt: "Will you be shown a score on each round?", options: ['Yes.', 'No, the score will only be displayed once at the end of the game.','No, the spider might forget to count the money on some rounds.'],  horizontal: false, required: true}
    ]
    data: {
      correct: {
        Q0 : '$-48 to $48'
        Q1: COST_CORRECT
        Q2: 'The better I perform the higher my bonus will be.'
        Q3: 'No, the amount of cash at each node of the web may be different each time.'
        Q4: "The values of the nodes walked through from start to finish."
        Q5: 'No, the spider might forget to count the money on some rounds.'
      }
      trial_id: "mouselab_quiz_scarce"
    }
  }

  no_scarce["mouselab_quiz"] = {
    preamble: ->  """
      <h1> Quiz </h1>

    """
    type: jsPsychSurveyMultiChoice

    questions: [
      {prompt: "What is the range of node values in the actual game?", options: ['$0 to $50', '$-10 to $10', '$-48 to $48', '$-100 to $100'], horizontal: false, required: true}
      {prompt: COST_QUESTION, options: COST_ANSWERS ,  horizontal: false, required: true}
      {prompt: "Will you receive a bonus?", options: ['No.', 'I will receive a $1 bonus regardless of my performance.', 'I will receive a $1 bonus if I perform well, otherwise I will receive no bonus.', 'The better I perform the higher my bonus will be.'],  horizontal: false, required: true}
      {prompt: "Will each round be the same?", options: ['Yes.','No, the amount of cash at each node of the web may be different each time.', 'No, the structure of the web will be different each time.'],  horizontal: false, required: true}
      {prompt: "What determines your score for a round?", options: ["The values of the nodes walked through from start to finish.", "The score for a round is random.", "How much time it takes to complete a round."],  horizontal: false, required: true}
      {prompt: "Will you be shown a score on each round?", options: ['Yes.', 'No, the score will only be displayed once at the end of the game.','No, the spider might forget to count the money on some rounds.'],  horizontal: false, required: true}
    ]
    data: {
      correct: {
        Q0 : '$-48 to $48'
        Q1: COST_CORRECT
        Q2: 'The better I perform the higher my bonus will be.'
        Q3: 'No, the amount of cash at each node of the web may be different each time.'
        Q4: "The values of the nodes walked through from start to finish."
        Q5: 'Yes.'
      }
      trial_id: "mouselab_quiz_noscarce"
    }
  }
  fullscreen = {
    type: jsPsychFullscreen,
    fullscreen_mode: true,
    conditional_function: ->
      console.log(INSTRUCTIONS_FAILED)
      return INSTRUCTIONS_FAILED
  }

  scarce["mouselab_instruct_loop"] =
    timeline: [fullscreen, mouselab_instructions_1, practice_trials, scarce["mouselab_instructions_2"], scarce["mouselab_quiz"]]
    conditional_function: ->
      if DEBUG
        return false
      else
        return true
    loop_function: (data) ->
      responses = data.last(1).values()[0].response
      for resp_id, response of responses
        if not (data.last(1).values()[0].correct[resp_id] == response)
          REPETITIONS += 1
          if REPETITIONS < MAX_REPETITIONS

            alert """You got at least one question wrong. We'll send you back to the instructions and then you can try again. Number of attempts left: #{MAX_REPETITIONS-REPETITIONS}."""
            INSTRUCTIONS_FAILED = true
            return true  # try again
      psiturk.saveData()
      return false

  no_scarce["mouselab_instruct_loop"] =
    timeline: [fullscreen, mouselab_instructions_1, practice_trials, no_scarce["mouselab_instructions_2"], no_scarce["mouselab_quiz"]]
    conditional_function: ->
      if DEBUG
        return false
      else
        return true
    loop_function: (data) ->
      responses = data.last(1).values()[0].response
      for resp_id, response of responses
        if not (data.last(1).values()[0].correct[resp_id] == response)
          REPETITIONS += 1
          if REPETITIONS < MAX_REPETITIONS
            alert """You got at least one question wrong. We'll send you back to the instructions and then you can try again. Number of attempts left: #{MAX_REPETITIONS-REPETITIONS}."""
            return true  # try again
      psiturk.saveData()
      return false


  no_distractor["final_quiz"] =
    on_start: ->
      SCORE = Math.round(SCORE * 100) / 100

    preamble: -> """
      <h1>Quiz</h1>

      Congratulations for making it to the end of the <em>Web of Cash</em> game!

      Your total score for the game was <strong>$#{SCORE}</strong>. The bonus that you receive will be based on this.
      <br><br>

      Please answer the following questions about the task before moving on to the questionnaires.

    """
    type: jsPsychSurveyMultiChoice
    data:
      trial_id: "final_quiz_nodistractor"
    on_finish: ->
      BONUS = calculateBonus().toFixed(2)
    questions: [
      {prompt: "What is the range of node values in the first step (closest to the start, in the center)?", options: ['$-4 to $4', '$-8 to $8', '$-48 to $48'], required: true}
      {prompt: "What is the range of node values in the middle?", options: ['$-4 to $4', '$-8 to $8', '$-48 to $48'], required: true}
      {prompt: "What is the range of node values in the last step (furthest from the start, the edges)?", options: ['$-4 to $4', '$-8 to $8', '$-48 to $48'], required: true}
      {prompt: COST_QUESTION, options: COST_ANSWERS, required: true}
      {prompt: "How motivated were you to perform the task?", options: ["Very unmotivated", "Slightly unmotivated", "Neither motivated nor unmotivated", "Slightly motivated", "Very motivated"], required: true}
    ]


  distractor["final_quiz"] =
    preamble: -> """
      <h1>Quiz</h1>
      Congratulations for making it to the end of the <em>Web of Cash</em> game!

      Your total score for the game was <strong>$#{SCORE}. The bonus that you receive at the end will be based on this.
      <br><br>
       Please answer the following questions about the task before moving on to the final game.

    """
    type: jsPsychSurveyMultiChoice
    data:
      trial_id: "final_quiz_distractor"
    on_finish: ->
      BONUS = calculateBonus().toFixed(2)
    questions: [
      {prompt: "What is the range of node values in the first step (closest to the start, in the center)?", options: ['$-4 to $4', '$-8 to $8', '$-48 to $48'], required: true}
      {prompt: "What is the range of node values in the middle?", options: ['$-4 to $4', '$-8 to $8', '$-48 to $48'], required: true}
      {prompt: "What is the range of node values in the last step (furthest from the start, the edges)?", options: ['$-4 to $4', '$-8 to $8', '$-48 to $48'], required: true}
      {prompt: COST_QUESTION, options: COST_ANSWERS, required: true}
      {prompt: "How motivated were you to perform the task?", options: ["Very unmotivated", "Slightly unmotivated", "Neither motivated nor unmotivated", "Slightly motivated", "Very motivated"], required: true}
    ]

  minimumTime = PARAMS.MIN_TIME
  if DEBUG
    minimumTime = null

  # Test trial structure
  MDP_TRIALS = getScarcityTrials NUM_TEST_TRIALS, NUM_UNREWARDED_TRIALS
  test_timeline = []
  pointer_idx = 0
  for numBlockTrials, idx in MDP_BLOCKS
    ready_screen = undefined
    if idx == 0
      ready_screen =
        type: jsPsychHtmlKeyboardResponse
        data:
          trial_id: "mdp_ready_" + (idx+1)
        choices: [" "]
        stimulus: """

          <h1> Get ready to start the game! </h1>

          Thank you for reading the instructions. Get ready start with the first of #{MDP_BLOCKS.length} block(s) of this game.
          <br><br>
          In this first block, you will complete #{numBlockTrials} rounds of this game before moving on.
          <br><br>
          Remember, the more money the spider gets, the bigger your bonus will be!
          <br><br>
          <div style='text-align: center;'>Press <code>space</code> to begin.</div>

          <br><br>
          (If, at any point, the <code>space</code> key does not take you to the next page, click once on the text and try again.)
        """
    else
      ready_screen =
        type: jsPsychHtmlKeyboardResponse
        data:
          trial_id: "mdp_ready_" + (idx+1)
        choices: [" "]
        stimulus: """
          <h1> End of block! </h1>

          You have reached the end of the block #{idx}/#{MDP_BLOCKS.length}. If you need a short break, feel free to take one now before moving on.

          <br><br>
          In the next block, you will complete another #{numBlockTrials} rounds of this game.

          <br><br>
          <div style='text-align: center;'>Press <code>space</code> to begin.</div>
          <br><br>
<div style='text-align: center;'>(If the experiment doesn't continue, try clicking on the text and then pressing <code>space</code>.)</div>
        """

    test_timeline.push ready_screen
    block_trials = MDP_TRIALS.slice(pointer_idx, pointer_idx + numBlockTrials)
    pointer_idx += numBlockTrials
    # TODO: Update to wait_for_click true - pilot v3.1
    test_trials = {
      type: jsPsychMouselabMDP
# display: $('#jspsych-target')
      graph: STRUCTURE.graph
      layout: STRUCTURE.layout
      initial: STRUCTURE.initial
      num_trials: numBlockTrials
      stateClickCost: () -> COST
      stateDisplay: 'click'
      accumulateReward: true
      wait_for_click: false
      scoreShift: 5
      minTime: minimumTime
      stateBorder : () -> "rgb(187,187,187,1)"#getColor
      playerImage: 'static/images/spider.png'
# trial_id: jsPsych.timelineVariable('trial_id',true)
      blockName: 'test' + (idx+1)
      lowerMessage: """
      Click on the nodes to reveal their values.<br>
      Move with the arrow keys after you are done clicking.
        """
      timeline: block_trials
      trialCount: () -> trialCount
      on_finish: () ->
        trialCount += 1
      on_timeline_finish: () ->
        trialCount = 0
    }
    test_timeline.push test_trials
  # All scarcity trials
#  test = {
#    type: jsPsychMouselabMDP
#    # display: $('#jspsych-target')
#    graph: STRUCTURE.graph
#    layout: STRUCTURE.layout
#    initial: STRUCTURE.initial
#    num_trials: NUM_MDP_TRIALS
#    stateClickCost: () -> COST
#    stateDisplay: 'click'
#    accumulateReward: true
#    wait_for_click: true
#    scoreShift: 5
#    minTime: minimumTime
#    stateBorder : () -> "rgb(187,187,187,1)"#getColor
#    playerImage: 'static/images/spider.png'
#    # trial_id: jsPsych.timelineVariable('trial_id',true)
#    blockName: 'test'
#    lowerMessage: """
#      Click on the nodes to reveal their values.<br>
#      Move with the arrow keys after you are done clicking.
#        """
#    timeline: getScarcityTrials NUM_TEST_TRIALS, NUM_UNREWARDED_TRIALS
#    trialCount: () -> trialCount
#    on_finish: () ->
#      trialCount += 1
#  }

  #final screen if participants didn't pass instructions quiz
  no_distractor["finish_fail"] = {
       type: jsPsychSurveyText
       data:
        trial_id: "finish_fail_nodistractor"
       preamble: ->  """
           <h1> You've completed the HIT </h1>

           Thanks for participating. Unfortunately we can only allow those who understand the instructions to continue with the HIT.

           You will receive only the base pay amount when you submit.

           Before you submit the HIT, we are interested in knowing some demographic info, and if possible, what problems you encountered with the instructions/HIT.
         """

       questions: [
         {prompt:'Was anything confusing or hard to understand?',required:false,rows:10}
         {prompt:'What is your age?',required:true}
         {prompt:'What is your gender?',required:true}
         {prompt:'Are you colorblind?',required:true, rows:2}
         {prompt:'Additional comments?',required:false,rows:10}
       ]
       button_label: 'Continue on to secret code'
     }

  distractor["finish_fail"] = {
    type: jsPsychSurveyText
    data:
      trial_id: "finish_fail_distractor"
    preamble: ->  """
           <h1> You've completed the HIT </h1>

           Thanks for participating. Unfortunately we can only allow those who understand the instructions to continue with the HIT.

           You will receive only the base pay amount earned for the first game when you submit.

           Before you submit the HIT, we are interested in knowing some demographic info, and if possible, what problems you encountered with the instructions/HIT.
         """

    questions: [
      {prompt:'Was anything confusing or hard to understand?',required:false,rows:10}
      {prompt:'What is your age?',required:true}
      {prompt:'What is your gender?',required:true}
      {prompt:'Are you colorblind?',required:true, rows:2}
      {prompt:'Additional comments?',required:false,rows:10}
    ]
    button_label: 'Continue on to secret code'
  }

  #final screen, if participants actually participated
  finish = {
    type: jsPsychSurveyText
    preamble: ->  """
        <h1> You've completed the HIT </h1>

        Thanks for participating. We hope you had fun! Based on your
        performance in all the games, you will be awarded a bonus to your account within the next few days.

        Please briefly answer the questions below before you submit the HIT.
      """

    questions: [
      {prompt: 'Was anything confusing or hard to understand?', required: false, rows:10}
      {prompt: "After completing this HIT, did you realize that you had already participated in a Web of Cash HIT before? Don't worry, we won't penalize you based on your response here. We completely understand that it's hard to remember which HITs you have or haven't completed.", required: true, rows:5}
      {prompt: 'Additional comments?', required: false, rows:10}
    ]
    button_label: 'Continue on to secret code'
  }

  #demographics
  demographics = {
    type: jsPsychSurveyHtmlForm
    preamble: "<h1>Demographics</h1> <br> Please answer the following questions.",
    html: """
      <p>
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
      </p>
    """
  }

  # ================================================ #
  # ========= TIMELINE LOGIC ======================= #
  # ================================================ #

  #if the subject fails the quiz 4 times they are just thanked and must leave
  no_distractor["if_node1"] =
    timeline: [no_distractor["finish_fail"]]
    conditional_function: ->
        if REPETITIONS > MAX_REPETITIONS
            return true
        else
            return false

  distractor["if_node1"] =
    timeline: [distractor["finish_fail"]]
    conditional_function: ->
      if REPETITIONS > MAX_REPETITIONS
        return true
      else
        return false


  # if the subject passes the quiz, they continue and can earn a bonus for their performance
  # createQuestionnaires("pptlr", QUESTIONNAIRES["pptlr"])
  no_distractor["if_node2"] =
    timeline: [test_timeline..., no_distractor["final_quiz"], demographics, finish]
    conditional_function: ->
      if REPETITIONS > MAX_REPETITIONS || DEBUG
        return false
      else
        return true

  no_distractor["if_node2_debug"] =
    timeline: [test_timeline..., finish]
    conditional_function: ->
      if REPETITIONS > MAX_REPETITIONS || !DEBUG
        return false
      else
        return true

  distractor["if_node2"] =
    timeline: [test_timeline..., distractor['final_quiz'], distractor["finish_webofcash"],
      distractor["color_game_instructions"], distractor["distractor_2_timeline"]...,
      distractor["finish_distractor_2"], demographics, finish]
    conditional_function: ->
      if REPETITIONS > MAX_REPETITIONS || DEBUG
        return false
      else
        return true

  distractor["if_node2_debug"] =
    timeline: [test_timeline..., distractor["final_quiz"], distractor["finish_webofcash"],
      distractor["color_game_instructions"], distractor["distractor_2_timeline"]...,
      distractor["finish_distractor_2"], finish]
    conditional_function: ->
      if REPETITIONS > MAX_REPETITIONS || !DEBUG
        return false
      else
        return true


  # experiment timeline up until now (conditional function properties of nodes keep if_node1 and if_node2 working as we want them)

  experiment_timeline = undefined
  # No scarcity and distractor trials present
  if CONDITION == 0
    experiment_timeline = [
      distractor["experiment_instructions"],
      distractor["color_game_instructions"],
      distractor["distractor_1_timeline"]...,
      distractor["finish_distractor"],
      no_scarce["mouselab_instruct_loop"]
      distractor["if_node1"],
      distractor["if_node2"],
      distractor["if_node2_debug"]
    ]
  else if CONDITION == (REWARDED_PROPORTIONS.length - 1)
    # Scarcity and no distractor trials present
    experiment_timeline = [
      no_distractor["experiment_instructions"],
      scarce["mouselab_instruct_loop"],
      no_distractor["if_node1"],
      no_distractor["if_node2"],
      no_distractor["if_node2_debug"]
    ]
  else
    # Scarcity and distractor trials present
    experiment_timeline = [
      distractor["experiment_instructions"],
      distractor["color_game_instructions"],
      distractor["distractor_1_timeline"]...,
      distractor["finish_distractor"],
      scarce["mouselab_instruct_loop"]
      distractor["if_node1"],
      distractor["if_node2"],
      distractor["if_node2_debug"]
    ]

  # ================================================ #
  # ========= START AND END THE EXPERIMENT ========= #
  # ================================================ #

  # experiment goes to full screen at start
  experiment_timeline.unshift({type:jsPsychFullscreen, message: '<p>The experiment will switch to full screen mode when you press the button below.<br> Please do not leave full screen for the duration of the experiment. </p>', button_label:'Continue', fullscreen_mode:true, delay_after:1000})

  # at end, show the secret code and then leave fullscreen
  secret_code_trial =
    type: jsPsychHtmlButtonResponse
    choices: ['Finish HIT']
    stimulus: () -> """
  The secret code is: <br><br><strong>" + PARAMS.CODE.toUpperCase() + "</strong>

      <br><br>

  Once you have copied this down, please <strong>press the 'Finish HIT' button</strong> and <strong>wait for the original webpage to tell you that you can close the window.</strong> If you close it before the webpage prompts you to, your progress may not be saved!

  """

  experiment_timeline.push(secret_code_trial)
  experiment_timeline.push({type:jsPsychFullscreen, fullscreen_mode:false, delay_after:1000})

  # bonus is the (roughly) total score multiplied by something, bounded by min and max amount
  calculateBonus = ->
    bonus = SCORE * PARAMS.bonusRate
    bonus = (Math.round (bonus * 100)) / 100  # round to nearest cent
    return Math.min(Math.max(0, bonus),MAX_AMOUNT)

  #saving, finishing functions
  reprompt = null
  save_data = ->
    psiturk.saveData
      success: ->
        console.log 'Data saved to psiturk server.'
        if reprompt?
          window.clearInterval reprompt
        await completeExperiment uniqueId # Encountering an error here? Try to use Coffeescript 2.0 to compile.
        psiturk.completeHIT();
      error: -> prompt_resubmit

  prompt_resubmit = ->
    $('#jspsych-target').html """
      <h1>Oops!</h1>
      <p>
      Something went wrong submitting your HIT.
      This might happen if you lose your internet connection.
      Press the button to resubmit.
      </p>
      <button id="resubmit">Resubmit</button>
    """
    $('#resubmit').click ->
      $('#jspsych-target').html 'Trying to resubmit...'
      reprompt = window.setTimeout(prompt_resubmit, 10000)
      save_data()

  # initialize jspsych experiment -- without this nothing happens
  jsPsych.run(experiment_timeline)