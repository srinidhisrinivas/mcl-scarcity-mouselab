# coffeelint: disable=max_line_length, indentation
DEBUG = true # change this to false before running the experiment
CONDITION = 0 # 0 or 1
JUMP_TO_BLOCK = 0

TRIALS_TRAINING = undefined
TRIALS_TRAINING = undefined
TRIALS_INNER_REVEALED = undefined
STRUCTURE_TRAINING = undefined
SCORE = 0
calculateBonus = undefined
getTrainingTrials = undefined
getTrialsWithInnerRevealed = undefined
getActionTrials = undefined
PARAMS = [
  inspectCost: 1,
  bonusRate: .002
]

_.mapObject = mapObject

psiturk = new PsiTurk uniqueId, adServerLoc, mode

delay = (time, func) -> setTimeout func, time

slowLoad = -> $('slow-load')?.show()

loadTimeout = delay 12000, slowLoad

if DEBUG
  JUMP_TO_BLOCK = window.prompt('skip to block number?', 0)

createStartButton = ->
  document.getElementById('loader').style.display = 'none'
  document.getElementById('successLoad').style.display = 'block'
  document.getElementById('failLoad').style.display = 'none'
  $('#load-btn').click initializeExperiment

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

$(window).resize -> checkWindowSize 800, 600, $('#jspsych-target')
$(window).resize()
$(window).on 'load', ->
  # Load data and test connection to server.
  slowLoad = -> $('slow-load')?.show()
  loadTimeout = delay 12000, slowLoad

  psiturk.preloadImages [
    'static/images/spider.png'
  ]

  delay 300, ->
    console.log 'Loading data'

    STRUCTURE_TRAINING = loadJson 'static/json/structure/312.json'
    TRIALS_TRAINING = loadJson 'static/json/mcrl_trials/increasing.json'
    TRIALS_ACTION = loadJson 'static/json/demo/312_action.json'
    TRIALS_INNER_REVEALED = loadJson 'static/json/demo/312_inner_revealed.json'
    console.log "loaded #{TRIALS_TRAINING?.length} training trials"

    getTrainingTrials = do ->
      t = _.shuffle TRIALS_TRAINING
      idx = 0
      return (n) ->
        idx += n
        t.slice(idx-n, idx)

    getTrialsWithInnerRevealed = do ->
      t = _.shuffle TRIALS_INNER_REVEALED
      idx = 0
      return (n) ->
        idx += n
        t.slice(idx-n, idx)

    getActionTrials = do ->
      t = _.shuffle TRIALS_ACTION
      idx = 0
      return (n) ->
        idx += n
        t.slice(idx-n, idx)

    console.log 'Testing saveData'
    saveData().then(->
      clearTimeout loadTimeout
      delay 500, createStartButton
    ).catch(->
      clearTimeout loadTimeout
      $('#data-error').show()
    )

createStartButton = ->
  initializeExperiment()
  $('#load-icon').hide()
  $('#slow-load').hide()
  $('#success-load').show()
  $('#load-btn').click initializeExperiment

initializeExperiment = ->
  $('#jspsych-target').html ''
  console.log 'INITIALIZE EXPERIMENT'
  text = ''

  # ================================= #
  # ========= BLOCK CLASSES ========= #
  # ================================= #

  class Block
      constructor: (config) ->
        _.extend(this, config)
        @_block = this  # allows trial to access its containing block for tracking state
        if @_init?
          @_init()

  class TextBlock extends Block
      type: 'text'
      cont_key: []

  class ButtonBlock extends Block
      type: 'button-response'
      is_html: true
      choices: ['Continue']
      button_html: '<button class="btn btn-primary btn-lg">%choice%</button>'

  class QuizLoop extends Block
      loop_function: (data) ->
        console.log 'data', data
        for c in data[data.length].correct
          if not c
            return true
        return false

  class MouselabBlock extends Block
      type: 'mouselab-mdp'
      playerImage: 'static/images/spider.png'
      lowerMessage: """
        <b>Clicking on a node reveals its value for a $1 fee.<br>
        Move with the arrow keys.</b>
    """

  class QuizLoop extends Block
      loop_function: (data) ->
        console.log 'data', data
        for c in data[data.length].correct
          if not c
            return true
        return false


  #  ============================== #
  #  ========= EXPERIMENT ========= #
  #  ============================== #

  welcome = new TextBlock
    text: ->
      """
        <h1>Mouselab-MDP Demo</h1>

        <p>
          This is a demonstration of the Mouselab-MDP plugin.
        </p>
        <p>
          Press <b>space</b> to continue.
        </p>
      """

  finish = new Block
    type: 'survey-text'
    preamble: ->
        markdown """
        # You've completed the HIT

        Thanks for participating. We hope you had fun! Based on your
        performance in Stage 1 and Stage 2, you will be awarded a bonus of
        **$#{calculateBonus().toFixed(2)}** on top of your base pay of $1.90.

        Please briefly answer the questions below before you submit the HIT.
        """
    questions: [
        #'How did you go about planning the path of the spider?'
        #'Did you learn anything about how to plan better?'
        'How old are you?'
        'Which gender do you identify with?' 
    ]
    rows: [4,4,1,1]
    button: 'Submit HIT'

  reset_score = new Block
    type: 'call-function'
    func: ->
      SCORE = 0

  divider = new TextBlock
    text: ->
      SCORE = 0
      "<div style='text-align: center;'> Press <code>space</code> to continue.</div>"

  survey = new Block
    type: 'survey-text'
    preamble: -> markdown """
        # Just one question ...

    """
    questions: ['What have you learned? What are you doing differently now from what you were doing at the beginning of this training session?' ]
    button: 'Finish'

  quiz = new Block
    preamble: -> markdown """
      # Quiz

      Please answer the following questions about the *Flight Planning* game.

    """
    type: 'survey-multi-choice'
    questions: [
      "What is the range of node values?"
      "What is the cost of clicking on a node to find out its value?"
      "Will each round be the same?"
    ]
    options: [
      ['$0 to $50', '$-10 to $10', '$-48 to $48', '$-100 to $100'],
      ['$0', '$1', '$5', '$10'],    
      ['Yes.','No, the amount of cash at each node of the web may be different each time.', 'No, the structure of the web will be different each time.']
    ]
    required: [true, true, true]
    correct: [
      '$-48 to $48'
      '$1'
      'No, the amount of cash at each node of the web may be different each time.'    
    ]

  demo_trial = new MouselabBlock
    show_feedback: false
    blockName: 'training'
    stateDisplay: 'click' # one of 'never', 'hover', 'click', 'always'
    stateClickCost: 1 # subtracted from score every time a state is clicked
    timeline: [{
      stateRewards:
        A: 10
        B: 0
        C: 0
    }]
    startScore: 50
    centerMessage: 'Demo trial'
    playerImageScale: 0.3
    size: 120 # determines the size of states, text, etc...
    _init: ->
      _.extend(this, {
        graph:  # defines transition and reward functions
          B:  # for each state, an object mapping actions to [reward, nextState]
            up: [5, 'A']  # states may be strings or numbers (be consistent!)
            down: [-5, 'C']
          A: {}
          C: {}
        layout:  # defines position of states
          A: [0, 1]
          B: [0, 2]
          C: [0, 3]
        initial: 'B'
      })
      @playerImage = 'static/images/plane.png'
      @trialCount = 0

  training_no_FB = new MouselabBlock
    minTime: 7
    show_feedback: false
    blockName: 'training'
    stateDisplay: 'click'
    stateClickCost: PARAMS.inspectCost
    timeline: getTrainingTrials 2
    startScore: 50
    centerMessage: 'No feedback'
    _init: ->
      _.extend(this, STRUCTURE_TRAINING)
      @playerImage = 'static/images/plane.png'
      @trialCount = 0

  training_with_actions_FB = new MouselabBlock
    minTime: 7
    show_feedback: false
    blockName: 'training'
    stateDisplay: 'click'
    stateClickCost: PARAMS.inspectCost
    timeline: getActionTrials 2
    startScore: 50
    centerMessage: 'Actions feedback'
    _init: ->
      _.extend(this, STRUCTURE_TRAINING)
      @playerImage = 'static/images/plane.png'
      @trialCount = 0

  training_with_optimal_FB = new MouselabBlock
    minTime: 7
    show_feedback: true
    blockName: 'training'
    stateDisplay: 'click'
    stateClickCost: PARAMS.inspectCost
    timeline: getTrainingTrials 2
    startScore: 50
    centerMessage: 'Optimal feedback'
    _init: ->
      _.extend(this, STRUCTURE_TRAINING)
      @playerImage = 'static/images/plane.png'
      @trialCount = 0

  training_with_inner_revealed = new MouselabBlock
    minTime: 7
    show_feedback: false
    blockName: 'training'
    stateDisplay: 'click'
    stateClickCost: PARAMS.inspectCost
    timeline: getTrialsWithInnerRevealed 2
    startScore: 50
    centerMessage: 'Inner nodes revealed'
    _init: ->
      _.extend(this, STRUCTURE_TRAINING)
      @playerImage = 'static/images/plane.png'
      @trialCount = 0


  if CONDITION == 0
    experiment_timeline = [
      training_with_inner_revealed
      training_no_FB
      training_with_actions_FB
      training_with_optimal_FB
      demo_trial
      finish
    ]
  else if CONDITION == 1
    experiment_timeline = [
      welcome
      quiz
      finish
    ]

  experiment_timeline = experiment_timeline.slice(JUMP_TO_BLOCK)

  calculateBonus = ->
    bonus = SCORE * PARAMS.bonusRate
    bonus = (Math.round (bonus * 100)) / 100  # round to nearest cent
    return Math.max(0, bonus)


  reprompt = null
  save_data = ->
    psiturk.saveData
      success: ->
        console.log 'Data saved to psiturk server.'
        if reprompt?
          window.clearInterval reprompt
        await $.ajax "complete_exp",
          type: "POST"
          data: {uniqueId}
        psiturk.computeBonus('compute_bonus', psiturk.completeHIT)
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

  # ================================================ #
  # ========= START AND END THE EXPERIMENT ========= #
  # ================================================ #

  jsPsych.init
    display_element: $('#jspsych-target')
    timeline: experiment_timeline
    # show_progress_bar: true

    on_finish: ->
      if DEBUG
        jsPsych.data.displayData()
      else
        psiturk.recordUnstructuredData 'final_bonus', calculateBonus()
        save_data()

    on_data_update: (data) ->
      console.log 'data', data
      # psiturk.recordTrialData data

