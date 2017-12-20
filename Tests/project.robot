*** Settings ***
Documentation                                       HB Case Study
Library                                             Collections
Library                                             Selenium2Library
Library                                             String
Variables                                           ../Recources/Variables.yaml

*** Variables ***
${browser}          chrome
${url}              http://www.hepsiburada.com/

*** Test Cases ***
First Test Case
    [Documentation]            User logins, search for a specific keyword, selects the first product from the search page and adds two products from two different merchants to the basket
    open browser               ${url}    ${browser}
    maximize browser window
    user goes to login page    https://www.hepsiburada.com/ayagina-gelsin/giris?ReturnUrl=%2f
    Login                      hbasguser@gmail.com  deneme123  Kamil Sever
    Search                     playstation
    Click first product from search page
    Scroll to merchant area in product detail page
    Add product to the basket from the first merchant
    Add product to the basket from the second merchant
    Quit Browser

Second Test Case
    [Documentation]            User searchs for a specific keyword, selects the first product from the search page and adds two products from two different merchants to the basket
    open browser               ${url}    ${browser}
    maximize browser window
    Search                     playstation
    Click first product from search page
    Scroll to merchant area in product detail page
    Add product to the basket from the first merchant
    Add product to the basket from the second merchant
    Quit Browser

*** Keywords ***
User goes to login page
    [Arguments]  ${go_to_url}
    go to  ${go_to_url}

Login
    [Arguments]  ${email}  ${password}  ${user_name}
    input text  ${Login.email}  ${email}
    input text  ${Login.password}  ${password}
    click element  ${Login.login_button}
    wait until page contains  ${user_name}

Search
    [Arguments]  ${keyword}
    input text  ${Search.productSearch}  ${keyword}
    click element  ${Search.buttonProductSearch}
    ${search_result}    get text    css=#productresults > header > h1
    element should contain  css=#productresults > header > h1  ${keyword}
    wait until page contains element  css=.product-detail

Click first product from search page
    ${products}    get webelements   css=.product-detail
    click element  ${products[0]}

Scroll to merchant area in product detail page
    ${product_detail_container}  get webelement  css=.product-detail-container
    scroll to "${product_detail_container}" element
    click element  id=merchantTabTrigger

Add product to the basket from the first merchant
    ${first_merchant_name}  get text  css=#merchant-list > tbody > tr:nth-child(2) > td.merchantName > div > a.small
    log to console  ${first_merchant_name}
    ${add_to_basket_buttons}  get webelements  css=.add-to-basket.button
    click element  ${add_to_basket_buttons[2]}
    page should contain  ${first_merchant_name}
    sleep  2
    go back

Add product to the basket from the second merchant
    scroll to merchant area in product detail page
    ${second_merchant_name}  get text  css=#merchant-list > tbody > tr:nth-child(3) > td.merchantName > div > a.small
    log to console  ${second_merchant_name}
    ${add_to_basket_buttons}  get webelements  css=.add-to-basket.button
    click element  ${add_to_basket_buttons[3]}
    page should contain  ${second_merchant_name}

Scroll to "${Element}" element
    wait until element is visible  ${Element}
    ${Height}    Get Vertical Position    ${Element}
    ${Height}    convert to integer    ${Height}
    ${Height}    evaluate    ${Height}+150
    Execute Javascript  window.scrollTo(0, ${Height})
    sleep    1

Quit Browser
    close all browsers
