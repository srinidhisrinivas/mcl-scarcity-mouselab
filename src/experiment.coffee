# coffeelint: disable=max_line_length, indentation

DEBUG = yes
DEBUG_SUBMIT = no
TALK = no

if DEBUG
  console.log """
  X X X X X X X X X X X X X X X X X
   X X X X X DEBUG  MODE X X X X X
  X X X X X X X X X X X X X X X X X
  """
  CONDITION = parseInt condition

else
  console.log """
  # =============================== #
  # ========= NORMAL MODE ========= #
  # =============================== #
  """
  console.log '16/01/18 12:38:03 PM'
  CONDITION = parseInt condition

if mode is "{{ mode }}"

  CONDITION = 0

COST_ANSWERS = ["There is no cost for clicking on nodes.", "Yes, but the cost for clicking on nodes varies.", "No, the cost is always $1.00.", "It is more costly to inspect 'sticky' nodes."]
COST_QUESTION = "Does the cost of clicking on a node to find out its value vary between nodes?"
COST_CORRECT= "No, the cost is always $1.00."

COST = [0,0,0][CONDITION]
DEPTH = [5,40,80][CONDITION]

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
SCORE = [50, 50, 50][CONDITION] #TODO EDIT MAX AMOUNT IF CHANGING THIS -- THIS IS TO MAKE CONDITIONS EQUAL
BONUS_RATE = .002
if DEBUG then NUM_BIAS_TRIALS = 3
else NUM_BIAS_TRIALS = 10
if DEBUG then NUM_TEST_TRIALS = 3
else NUM_TEST_TRIALS = 30
NUM_TRIALS =  NUM_TEST_TRIALS + NUM_BIAS_TRIALS
MAX_AMOUNT = BONUS_RATE*(NUM_TRIALS*(4+8+48)+800)
trialCount = 0
calculateBonus = undefined
getCost = undefined
getColor = undefined
colorInterpolation = undefined
getClickCosts = undefined
getTrials = undefined
getRevealedTrials = undefined
createQuestionnaires = undefined
bonus_text = undefined
early_nodes = undefined
final_nodes = undefined

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
      CODE : ['hedgehog','bighorn','chinchilla','porcupine','guanaco','walrus','dromedary','aoudad','weasel','rooster','civet','iguana','fruitbat','reindeer','bobcat','fieldmouse'][CONDITION % 16]
      DEPTH : DEPTH
      COST : COST
      MIN_TIME : 7
      inspectCost: 1
      startTime: Date(Date.now())
      bonusRate: BONUS_RATE
      variance: '2_4_24'
      branching: '312'
      first_trial: (Math.random() >= 0.5)
      colors:  ['#1b9e77','#d95f02','#7570b3']
      color_names: ['Green', 'Orange', 'Purple']


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

    early_nodes = Object.values(STRUCTURE.graph[STRUCTURE["initial"]]).map (val) -> val[1]
    final_nodes = (([1.._.size(STRUCTURE.graph)]).filter (x) -> _.isEmpty(STRUCTURE.graph[x])).map(String)

    getCost = (node_label) ->
      if node_label in early_nodes
        return COST + DEPTH * 1
      if node_label in final_nodes
        return COST + DEPTH * 3
      return COST + DEPTH * 2

    getClickCosts = () ->
      click_costs =  [1,1,1,1,1,1,1,1,1,1,1,1,1]
      depths = [0,0,1,2,2,0,1,2,2,0,1,2,2]
      DEPTH * depths[idx] + COST * click for click, idx in click_costs

    getColor = (node_label) ->
      if (node_label in early_nodes) or (DEPTH == 0)
        return PARAMS.colors[0]
      if node_label in final_nodes
        return PARAMS.colors[2]
      return PARAMS.colors[1]

    colorInterpolation  = (start, end) ->
      max_color = Math.max getClickCosts()...
      final_color = [187,187,187]
      starting_color = [101,67,33]
      pctg = if (start == end) then 1 else ((max_color-(end-start))/(max_color))*.70

      r_channel = starting_color[0] + pctg * (final_color[0]-starting_color[0])
      g_channel = starting_color[1] + pctg * (final_color[1]-starting_color[1])
      b_channel = starting_color[2] + pctg * (final_color[2]-starting_color[2])

      return "rgba(#{r_channel},#{g_channel},#{b_channel})"

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
      createStartButton
      clearTimeout loadTimeout
    else
      saveData()
        .then ->
          clearTimeout loadTimeout
          delay 500, createStartButton
        .catch ->
          clearTimeout loadTimeout
          $('#data-error').show()

createQuestionnaires = (quest_id, quest_data) ->
  sum_fn = (a,b) -> a+b.length+5
  length_of_options = Math.max \
                (quest_data["questions"].map (question) -> question.labels.reduce sum_fn, 0)...
  horizontal = (length_of_options<65)

  questionnaire_trial = {
    type: 'survey-multi-choice'
    randomize_question_order: false
    preamble: quest_data["preamble"]
    questions: quest_data["questions"].map (question) -> {prompt: question.prompt, name: question.question_id, options: question.labels, required:true, horizontal:horizontal}
    data: {
      name: quest_data["name"]
      reverse_coded: quest_data["questions"].map (question) -> question['reverse_coded']
      question_id: quest_data["questions"].map (question) -> question['question_id']
    }
  }
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

  instructions = {
    type: 'instructions'
    on_start: () ->
      psiturk.finishInstructions() #started instructions, so no longer worth keeping in database
    show_clickable_nav: true
    pages: -> [
         """
        <h1> Instructions </h1>

        In this HIT, you will play #{NUM_TRIALS} rounds of the <em>Web of Cash</em> game.  First you will be given the instructions and answer some questions to check your understanding of the game. The whole HIT will take about 30 minutes.

        The better you perform, the higher your bonus will be.

      """

         """
        <h1>The Spider Web</h1>

        In the <em>Web of Cash</em> game you will guide a money-loving spider through a spider web. When you land on a gray circle
        (a <strong><em>node</strong></em>) the value of the node is added to your score.

        You will be able to move the spider with the arrow keys, but only in the direction
        of the arrows between the nodes. The image below shows the shape of all the webs that you will be navigating in when the game starts.

       <img class='display' style="width:50%; height:auto" src='static/images/web-of-cash-unrevealed.png'/>

      """

         """
        <h1> <em>Web of Cash</em> Node Inspector (1/2) </h1>

        It's hard to make good decision when you can't see what you will get!
        Fortunately, in the <em>Web of Cash</em> game you will have access to a <strong><em>node inspector</strong></em> which can reveal
        the value of a node. To use the node inspector, you must <strong><em>click on a node</strong></em>. The image below illustrates how this works.
        <br>
        <strong>Note:</strong> you can only use the node inspector when you're on the starting
        node.

        <img class='display' style="width:50%; height:auto" src='static/images/web-of-cash.png'/>


      """

       """
      <h1> <em>Web of Cash</em> Node Inspector (2/2) </h1>

      The node inspector always costs $1 to reveal one node. The $1 fee will be instantly deducted from the spider's money (the score) in the top right corner.
      <br>
      <br>
      There's one catch! The spider web tends to get a bit sticky. You may have to click multiple times to clean a node before using the node inspector to find the node's value. A node's color will go from brown to grey as it gets cleaner and closer to being revealed. When you hover over a node, a blue number will appear showing the number of clicks still needed (see the image below.) When a node's color matches the color of its grey border, it is ready to be inspected. The node inspector fee will be charged <strong>only on the final click as the node is revealed</strong> (i.e. <strong>there is no cost for clicking on a node to clean it.</strong>)
      <br>
      <br>
      Some nodes are harder to uncover than others, <strong>for example you may need to click 5 times for one node vs. 50 times for another.</strong>

      <img class='display' style="width:50%; height:auto" src='static/images/sticky_nodes.png'/>


    """
         """
        <h1> Rewards and Costs (2/2) </h1>
        <div style="text-align: left">
        <li>Each node of the web either contains a reward of up to <strong><font color='green'>$48</font></strong> or a loss of up to <strong><font color='red'>$-48</font></strong></li>
        <li>You can find out about a node's loss or reward by using the node inspector, which costs <strong>$1 per revealed node.</strong></li>
        </div>


      """
      """
      <h1> Bonus </h1>

      The more money the spider gets, the bigger your bonus will be!  Concretely, #{bonus_text('long')}

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

  #instructions quiz -- they have limited tries (MAX_REPETITIONS) here
  quiz = {
    preamble: ->  """
      <h1> Quiz </h1>

    """
    type: 'survey-multi-choice'
    questions: [
      {prompt: "What is the range of node values?", options: ['$0 to $50', '$-10 to $10', '$-48 to $48', '$-100 to $100'], horizontal: false, required: true}
      {prompt: COST_QUESTION, options: COST_ANSWERS ,  horizontal: false, required: true}
      {prompt: "Will you receive a bonus?", options: ['No.', 'I will receive a $1 bonus regardless of my performance.', 'I will receive a $1 bonus if I perform well, otherwise I will receive no bonus.', 'The better I perform the higher my bonus will be.'],  horizontal: false, required: true}
      {prompt: "Will each round be the same?", options: ['Yes.','No, the amount of cash at each node of the web may be different each time.', 'No, the structure of the web will be different each time.'],  horizontal: false, required: true}
      {prompt: "If a node you want to inspect is 'sticky' what should you do?", options: ['Keep clicking for $1 a click, up until the cost is too high.','Click until the node is dark grey and can be inspected for $1.', 'Find another node to inspect as the node is blocked.'],  horizontal: false, required: true}
      {prompt: "Which statment is true about 'sticky' nodes?", options: ['All sticky nodes can be cleaned by clicking 10 times.', 'Some nodes are so sticky you can\'t clean them.', 'The number of clicks needed to clean a sticky node can vary.'],  horizontal: false, required: true}
    ]
    data: {
      correct: {
        Q0 : '$-48 to $48'
        Q1: COST_CORRECT
        Q2: 'The better I perform the higher my bonus will be.'
        Q3: 'No, the amount of cash at each node of the web may be different each time.'
        Q4: 'Click until the node is dark grey and can be inspected for $1.'
        Q5: 'The number of clicks needed to clean a sticky node can vary.'
      }
    }
  }



  instruct_loop = {
    timeline: [instructions, quiz]
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
    }



  additional_base = {
    type: "html-keyboard-response"
    choices: [" "]
    stimulus: """
        <h1> Get ready to start the game! </h1>

        Thank you for reading the instructions.

        We will give the spider $#{SCORE} to start. Remember, the more money the spider gets, the bigger your bonus will be!  Concretely, #{bonus_text('long')}

        <div style='text-align: center;'>Press <code>space</code> to begin.</div>
        """
    }


  final_quiz = {
    preamble: -> """
      <h1>Quiz</h1>

      Based on your performance, you will be awarded a total bonus of <strong>$#{calculateBonus().toFixed(2)}</strong>. Please answer the following questions about the task before moving onto the questionnaires.

    """
    type: 'survey-multi-choice'
    on_finish: ->
      BONUS = calculateBonus().toFixed(2)
    questions: [
      {prompt: "What is the range of node values in the first step (closest to the start, in the center)?", options: ['$-4 to $4', '$-8 to $8', '$-48 to $48'], required: true}
      {prompt: "What is the range of node values in the middle?", options: ['$-4 to $4', '$-8 to $8', '$-48 to $48'], required: true}
      {prompt: "What is the range of node values in the last step (furthest from the start, the edges)?", options: ['$-4 to $4', '$-8 to $8', '$-48 to $48'], required: true}
      {prompt: COST_QUESTION, options: COST_ANSWERS, required: true}
      {prompt: "How motivated were you to perform the task?", options: ["Very unmotivated", "Slightly unmotivated", "Neither motivated nor unmotivated", "Slightly motivated", "Very motivated"], required: true}
    ]
    }

  click_costs = getClickCosts()

  # typical 30 test trials, with extra cost component
  test = {
    type: 'mouselab-mdp'
    # display: $('#jspsych-target')
    graph: STRUCTURE.graph
    layout: STRUCTURE.layout
    initial: STRUCTURE.initial
    num_trials: NUM_TRIALS
    stateClickCost: () -> 1
    num_clicks_needed: click_costs
    # stateRewards: jsPsych.timelineVariable('stateRewards',true)
    stateDisplay: 'click'
    minTime: PARAMS.MIN_TIME
    wait_for_click: true
    stateBorder : () -> "rgb(187,187,187,1)"#getColor
    colorInterpolation: colorInterpolation
    playerImage: 'static/images/spider.png'
    # trial_id: jsPsych.timelineVariable('trial_id',true)
    blockName: 'test'
    lowerMessage: """
      Click on the nodes to reveal their values.<br>
      Move with the arrow keys.
      <br><br>
      #{COST_EXPLANATION}
        """
    timeline: getTrials NUM_TEST_TRIALS
    trialCount: () -> trialCount
    on_finish: () ->
      trialCount += 1
  }

  # test to see if participants stay biased
  bias_test = {
    type: 'mouselab-mdp'
    # display: $('#jspsych-target')
    graph: STRUCTURE.graph
    layout: STRUCTURE.layout
    initial: STRUCTURE.initial
    num_trials: NUM_TRIALS
    stateClickCost: () -> 1
    num_clicks_needed: [0,0,0,0,0,0,0,0,0,0,0,0,0]
    # stateRewards: jsPsych.timelineVariable('stateRewards',true)
    stateDisplay: 'click'
    minTime: PARAMS.MIN_TIME
    wait_for_click: true
    stateBorder : () -> "rgb(187,187,187,1)"#getColor
    colorInterpolation: colorInterpolation
    playerImage: 'static/images/spider.png'
    # trial_id: jsPsych.timelineVariable('trial_id',true)
    blockName: 'bias_test'
    lowerMessage: """
      Click on the nodes to reveal their values.<br>
      Move with the arrow keys.
      <br><br>
      #{COST_EXPLANATION}
        """
    timeline: getTrials NUM_BIAS_TRIALS
    trialCount: () -> trialCount
    on_finish: () ->
      trialCount += 1
  }

  #final screen if participants didn't pass instructions quiz
  finish_fail = {
       type: 'survey-text'
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

  #final screen, if participants actually participated
  finish = {
    type: 'survey-text'
    preamble: ->  """
        <h1> You've completed the HIT </h1>

        Thanks for participating. We hope you had fun! Based on your
        performance, you will be awarded a bonus of
        <strong>$#{BONUS}</strong>.

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
    type: 'survey-html-form',
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
  if_node1 = {
    timeline: [finish_fail]
    conditional_function: ->
        if REPETITIONS > MAX_REPETITIONS
            return true
        else
            return false
    }

  # if the subject passes the quiz, they continue and can earn a bonus for their performance
  if_node2 = {
    timeline: [additional_base, test, bias_test, final_quiz, createQuestionnaires("pptlr", QUESTIONNAIRES["pptlr"]), demographics, finish]
    conditional_function: ->
      if REPETITIONS > MAX_REPETITIONS
        return false
      else
        return true
    }

  # experiment timeline up until now (conditional function properties of nodes keep if_node1 and if_node2 working as we want them)
  experiment_timeline = [
    additional_base
    instruct_loop
    if_node1
    if_node2
  ]

  # ================================================ #
  # ========= START AND END THE EXPERIMENT ========= #
  # ================================================ #

  # experiment goes to full screen at start
  experiment_timeline.unshift({type:"fullscreen", message: '<p>The experiment will switch to full screen mode when you press the button below.<br> Please do not leave full screen for the duration of the experiment. </p>', button_label:'Continue', fullscreen_mode:true, delay_after:1000})

  # at end, show the secret code and then leave fullscreen
  secret_code_trial = {
      type: 'html-button-response'
      choices: ['Finish HIT']
      stimulus: () -> "The secret code is <strong>" + PARAMS.CODE.toUpperCase() + "</strong>. Please press the 'Finish HIT' button once you've copied it down to paste in the original window."
    }
  experiment_timeline.push(secret_code_trial)
  experiment_timeline.push({type:"fullscreen", fullscreen_mode:false, delay_after:1000})

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
        psiturk.computeBonus('compute_bonus')
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
  jsPsych.init
    display_element: 'jspsych-target'
    timeline: experiment_timeline
    # show_progress_bar: true

    on_finish: ->
      if DEBUG and not DEBUG_SUBMIT
        jsPsych.data.displayData()
      else
        psiturk.recordUnstructuredData 'final_bonus', calculateBonus()
        psiturk.recordUnstructuredData 'displayed_bonus', BONUS
        save_data()

    on_data_update: (data) ->
      # console.log 'data', data
      psiturk.recordTrialData data
      psiturk.saveData()