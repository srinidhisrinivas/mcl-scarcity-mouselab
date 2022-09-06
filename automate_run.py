from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import traceback

debug = False

num_stroop_blocks = 5
num_stroop_trials = 90

num_mdp_trials = 30

num_automations_done = 33
num_automations_to_do = 5



for run_num in range(num_automations_done + 1, num_automations_done + num_automations_to_do + 1):

    stroop_1_block = 0
    stroop_1_trial = 0
    stroop_2_block = 0
    stroop_2_trial = 0
    mdp_prac_trial = 0
    mdp_trial = 0

    name = "automated{}".format(run_num)
    print("Running {}".format(name))
    link = "https://mcl-scarcity.herokuapp.com/turkprime?hitId={}&assignmentId={}&workerId={}&mode=live".format(name,name,name)
    if debug:
        link = "http://localhost:22362/turkprime?hitId={}&assignmentId={}&workerId={}&mode=live".format(name,name,name)
    try:
        browser = webdriver.Chrome()
        browser.get(link)

        myElem = WebDriverWait(browser, 3).until(EC.presence_of_element_located((By.CLASS_NAME, 'btn-primary')))
        browser.find_element(By.CLASS_NAME, 'btn-primary').send_keys(Keys.ENTER)

        # Store the ID of the original window
        original_window = browser.current_window_handle

        # Wait for the new window or tab
        WebDriverWait(browser, 5).until(EC.number_of_windows_to_be(2))

        # Loop through until we find a new window handle
        for window_handle in browser.window_handles:
            if window_handle != original_window:
                browser.switch_to.window(window_handle)
                break

        myElem = WebDriverWait(browser, 3).until(EC.presence_of_element_located((By.CLASS_NAME, 'btn-primary')))
        browser.find_element(By.CLASS_NAME, 'btn-primary').send_keys(Keys.ENTER)

        myElem = WebDriverWait(browser, 3).until(EC.presence_of_element_located((By.CLASS_NAME, 'jspsych-btn')))
        browser.find_element(By.CLASS_NAME, 'jspsych-btn').send_keys(Keys.ENTER)
        myElem = WebDriverWait(browser, 3).until(EC.presence_of_element_located((By.ID, 'jspsych-instructions-next')))
        browser.find_element(By.ID, 'jspsych-instructions-next').send_keys(Keys.ENTER)
        myElem = WebDriverWait(browser, 3).until(EC.presence_of_element_located((By.ID, 'jspsych-instructions-next')))
        browser.find_element(By.ID, 'jspsych-instructions-next').send_keys(Keys.ENTER)
        for stroop_1_block in range(num_stroop_blocks):
            myElem = WebDriverWait(browser, 3).until(EC.visibility_of_element_located((By.ID, "jspsych-html-keyboard-response-stimulus")))
            browser.find_element(By.ID, 'jspsych-target').send_keys(Keys.SPACE)
            for stroop_1_trial in range(num_stroop_trials):
                elem = WebDriverWait(browser, 3).until(EC.presence_of_element_located((By.CLASS_NAME, 'stroop-trial')))
                browser.find_element(By.ID, 'jspsych-target').send_keys("R")

        myElem = WebDriverWait(browser, 3).until(EC.presence_of_element_located((By.ID, 'jspsych-instructions-next')))
        browser.find_element(By.ID, 'jspsych-instructions-next').send_keys(Keys.ENTER)

        myElem = WebDriverWait(browser, 3).until(EC.presence_of_element_located((By.CLASS_NAME, 'jspsych-btn')))
        browser.find_element(By.CLASS_NAME, 'jspsych-btn').send_keys(Keys.ENTER)
        myElem = WebDriverWait(browser, 3).until(EC.presence_of_element_located((By.ID, 'jspsych-instructions-next')))
        browser.find_element(By.ID, 'jspsych-instructions-next').send_keys(Keys.ENTER)
        myElem = WebDriverWait(browser, 3).until(EC.presence_of_element_located((By.ID, 'jspsych-instructions-next')))
        browser.find_element(By.ID, 'jspsych-instructions-next').send_keys(Keys.ENTER)
        myElem = WebDriverWait(browser, 3).until(EC.presence_of_element_located((By.ID, 'jspsych-instructions-next')))
        browser.find_element(By.ID, 'jspsych-instructions-next').send_keys(Keys.ENTER)
        myElem = WebDriverWait(browser, 3).until(EC.presence_of_element_located((By.ID, 'jspsych-instructions-next')))
        browser.find_element(By.ID, 'jspsych-instructions-next').send_keys(Keys.ENTER)
        myElem = WebDriverWait(browser, 3).until(EC.presence_of_element_located((By.ID, 'jspsych-instructions-next')))
        browser.find_element(By.ID, 'jspsych-instructions-next').send_keys(Keys.ENTER)
        time.sleep(3)
        for mdp_prac_trial in range(2):
            time.sleep(1)
            myElem = WebDriverWait(browser, 3).until(EC.presence_of_element_located((By.ID, 'mouselab-canvas')))
            browser.find_element(By.ID, 'jspsych-target').send_keys(Keys.ARROW_RIGHT)
            time.sleep(1)
            browser.find_element(By.ID, 'jspsych-target').send_keys(Keys.ARROW_RIGHT)
            time.sleep(1)
            browser.find_element(By.ID, 'jspsych-target').send_keys(Keys.ARROW_DOWN)
            time.sleep(1)
            browser.find_element(By.ID, 'jspsych-target').send_keys(Keys.SPACE)

        myElem = WebDriverWait(browser, 3).until(EC.presence_of_element_located((By.ID, 'jspsych-instructions-next')))
        browser.find_element(By.ID, 'jspsych-instructions-next').send_keys(Keys.ENTER)
        myElem = WebDriverWait(browser, 3).until(EC.presence_of_element_located((By.ID, 'jspsych-instructions-next')))
        browser.find_element(By.ID, 'jspsych-instructions-next').send_keys(Keys.ENTER)
        myElem = WebDriverWait(browser, 3).until(EC.presence_of_element_located((By.ID, 'jspsych-instructions-next')))
        browser.find_element(By.ID, 'jspsych-instructions-next').send_keys(Keys.ENTER)
        myElem = WebDriverWait(browser, 3).until(EC.presence_of_element_located((By.ID, "jspsych-survey-multi-choice-option-0-2")))
        browser.find_element(By.ID, "jspsych-survey-multi-choice-response-0-2").click()
        browser.find_element(By.ID, "jspsych-survey-multi-choice-response-1-2").click()
        browser.find_element(By.ID, "jspsych-survey-multi-choice-response-2-3").click()
        browser.find_element(By.ID, "jspsych-survey-multi-choice-response-3-1").click()
        browser.find_element(By.ID, "jspsych-survey-multi-choice-response-4-0").click()
        browser.find_element(By.ID, "jspsych-survey-multi-choice-response-5-0").click()
        browser.find_element(By.CLASS_NAME, 'jspsych-btn').send_keys(Keys.ENTER)

        myElem = WebDriverWait(browser, 3).until(EC.visibility_of_element_located((By.ID, "jspsych-html-keyboard-response-stimulus")))
        browser.find_element(By.ID, 'jspsych-target').send_keys(Keys.SPACE)
        time.sleep(3)
        for mdp_trial in range(num_mdp_trials):
            time.sleep(1)
            myElem = WebDriverWait(browser, 3).until(EC.presence_of_element_located((By.ID, 'mouselab-canvas')))
            browser.find_element(By.ID, 'jspsych-target').send_keys(Keys.ARROW_RIGHT)
            time.sleep(1)
            browser.find_element(By.ID, 'jspsych-target').send_keys(Keys.ARROW_RIGHT)
            time.sleep(1)
            browser.find_element(By.ID, 'jspsych-target').send_keys(Keys.ARROW_DOWN)
            time.sleep(1)
            browser.find_element(By.ID, 'jspsych-target').send_keys(Keys.SPACE)
            time.sleep(1)

        myElem = WebDriverWait(browser, 3).until(EC.presence_of_element_located((By.ID, "jspsych-survey-multi-choice-option-0-2")))
        browser.find_element(By.ID, "jspsych-survey-multi-choice-response-0-1").click()
        browser.find_element(By.ID, "jspsych-survey-multi-choice-response-1-1").click()
        browser.find_element(By.ID, "jspsych-survey-multi-choice-response-2-1").click()
        browser.find_element(By.ID, "jspsych-survey-multi-choice-response-3-1").click()
        browser.find_element(By.ID, "jspsych-survey-multi-choice-response-4-0").click()
        browser.find_element(By.CLASS_NAME, 'jspsych-btn').send_keys(Keys.ENTER)

        myElem = WebDriverWait(browser, 3).until(EC.presence_of_element_located((By.ID, 'jspsych-instructions-next')))
        browser.find_element(By.ID, 'jspsych-instructions-next').send_keys(Keys.ENTER)

        myElem = WebDriverWait(browser, 3).until(EC.presence_of_element_located((By.ID, 'jspsych-instructions-next')))
        browser.find_element(By.ID, 'jspsych-instructions-next').send_keys(Keys.ENTER)
        for stroop_2_block in range(num_stroop_blocks):
            myElem = WebDriverWait(browser, 3).until(EC.visibility_of_element_located((By.ID, "jspsych-html-keyboard-response-stimulus")))
            browser.find_element(By.ID, 'jspsych-target').send_keys(Keys.SPACE)
            for stroop_2_trial in range(num_stroop_trials):
                elem = WebDriverWait(browser, 3).until(EC.presence_of_element_located((By.CLASS_NAME, 'stroop-trial')))
                browser.find_element(By.ID, 'jspsych-target').send_keys("R")

        myElem = WebDriverWait(browser, 3).until(EC.presence_of_element_located((By.ID, 'jspsych-instructions-next')))
        browser.find_element(By.ID, 'jspsych-instructions-next').send_keys(Keys.ENTER)

        myElem = WebDriverWait(browser, 3).until(EC.presence_of_element_located((By.NAME, "gender")))
        browser.find_element(By.NAME, "gender").click()
        browser.find_element(By.NAME, "age").send_keys("24")
        browser.find_element(By.NAME, "colorblind").click()
        browser.find_element(By.NAME, "effort").click()
        browser.find_element(By.CLASS_NAME, 'jspsych-btn').send_keys(Keys.ENTER)

        myElem = WebDriverWait(browser, 3).until(EC.presence_of_element_located((By.NAME, "#jspsych-survey-text-response-1")))
        browser.find_element(By.NAME, "#jspsych-survey-text-response-1").send_keys("no")
        browser.find_element(By.CLASS_NAME, 'jspsych-btn').send_keys(Keys.ENTER)

        myElem = WebDriverWait(browser, 3).until(EC.presence_of_element_located((By.CLASS_NAME, 'jspsych-btn')))
        browser.find_element(By.CLASS_NAME, 'jspsych-btn').send_keys(Keys.ENTER)
        print("\nFinished run {}".format(run_num))

        browser.switch_to.window(original_window)
        time.sleep(5)
        browser.quit()
    except Exception as e:
        print("\nErrored out on run number {}".format(run_num))
        traceback.print_exc()
        print("Stroop 1 blocks: " + str(stroop_1_block))
        print("Stroop 1 trials: " + str(stroop_1_trial))
        print("MDP practice trials: " + str(mdp_prac_trial))
        print("MDP trials: " + str(mdp_trial))
        print("Stroop 2 blocks: " + str(stroop_2_block))
        print("Stroop 2 trials: " + str(stroop_2_trial))
        continue

