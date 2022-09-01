from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time


link = "http://localhost:22362/exp?hitId=debug9JO2f&assignmentId=debug1tZoD&workerId=debugJAt10&mode=debug"
browser = webdriver.Chrome()
browser.get(link)
myElem = WebDriverWait(browser, 3).until(EC.presence_of_element_located((By.CLASS_NAME, 'jspsych-btn')))
browser.find_element(By.CLASS_NAME, 'jspsych-btn').send_keys(Keys.ENTER)
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
for i in range(2):
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
browser.find_element(By.ID, "jspsych-survey-multi-choice-response-5-2").click()
browser.find_element(By.CLASS_NAME, 'jspsych-btn').send_keys(Keys.ENTER)

myElem = WebDriverWait(browser, 3).until(EC.visibility_of_element_located((By.ID, "jspsych-html-keyboard-response-stimulus")))
browser.find_element(By.ID, 'jspsych-target').send_keys(Keys.SPACE)

for i in range(8):
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
