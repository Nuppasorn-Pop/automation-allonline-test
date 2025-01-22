*** Settings ***
Library    SeleniumLibrary

Test Teardown    Close Browser

*** Variables ***
${URL}    https://www.allonline.7eleven.co.th/
${BROWSER}    chrome


*** Test Cases ***
สั่งซื้อสินค้า ไมโลบาร์ โดยเลือกรับที่ร้าน และชำระเงินด้วยบัตรเดบิตสำเร็จ
    เปิดบราวเซอร์ allonline และเข้าสู่ระบบ    test1234@gmail.com    test1234
    ตรวจสอบการเข้าสู่ระบบ พบชื่อผู้ใช้งาน    นัทธา ศิริไล
    ค้นหาสินค้า    ไมโลบาร์
    ตรวจสอบการค้นหาพบสินค้า    ไมโลบาร์ ช็อกโกแลต 30 กรัม    ฿ 68
    เพิ่มสินค้าลงตะกร้า    6
    ตรวจสอบจำนวนสินค้าในตะกร้า    6
    ตรวจสอบรายการสินค้าในตะกร้าว่ามีสินค้า    ไมโลบาร์ ช็อกโกแลต 30 กรัม    6    ฿ 408
    ชำระสินค้า เลือกการจัดส่งโดยรับที่ร้าน และเลือกรหัสสาขา    00903
    ตรวจสอบที่อยู่เซเว่นอีเลฟเว่นที่ไปรับ เซเว่นอีเลฟเว่น    0816138216    เซเว่นอีเลฟเว่น #00903     สาขา สนามกอล์ฟทหารบก     เลขที่ ถ.รามอินทรา, 459, แขวงอนุสาวรีย์ เขตบางเขน กรุงเทพฯ 10220
    ดำเนินการชำระเงิน เลือกชำระเงินด้วยบัตรเดบิต
    ตรวจสอบสรุปรายการสั่งซื้อสินค้า    นัทธา ศิริไล    เบอร์โทรศัพท์ผู้รับสินค้า: 0816138216    เซเว่นอีเลฟเว่น #00903     สาขา สนามกอล์ฟทหารบก     เลขที่ ถ.รามอินทรา, 459, แขวงอนุสาวรีย์ เขตบางเขน กรุงเทพฯ 10220    ไมโลบาร์ ช็อกโกแลต 30 กรัม    6    408    408    ฟรี    408    1,320    


*** Keywords ***
เปิดบราวเซอร์ allonline และเข้าสู่ระบบ
    [Arguments]    ${อีเมล}    ${รหัสผ่าน}
    Open Browser    url=${URL}    browser=${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible    class:header-service
    Click Element    class:btn-allmember-login
    Wait Until Element Is Visible    class:login-container
    Input Text    class:input-email-form    ${อีเมล}
    Input Text    class:input-password-form    ${รหัสผ่าน}
    Click Element    xpath=/html/body/div[1]/div/div/div[2]/div[2]/div/div/div/div[6]/a[1]

ตรวจสอบการเข้าสู่ระบบ พบชื่อผู้ใช้งาน
    [Arguments]    ${ชื่อผู้ใช้งาน}
    Wait Until Element Is Visible    class:header-service
    Element Should Contain    class:ellipsis-330    ${ชื่อผู้ใช้งาน}

ค้นหาสินค้า
    [Arguments]    ${คำค้นหา}
    Input Text    name=q    ${คำค้นหา}
    Submit Form    id:search_id_form

ตรวจสอบการค้นหาพบสินค้า
    [Arguments]    ${ชื่อสินค้า}    ${ราคา}
    Wait Until Element Is Visible    class:product-list
    Element Should Contain    class:item-description-cls-mobile    ${ชื่อสินค้า}
    Element Should Contain    class:price-bottom    ${ราคา}

คลิกเพิ่มสินค้า
    [Arguments]    ${times}
    FOR    ${index}    IN RANGE    ${times}
        Click Element    xpath=//*[@id="article-form"]/div[2]/div[2]/div[1]/span[2]/a
    END

เพิ่มสินค้าลงตะกร้า
    [Arguments]    ${จำนวน}
    Click Element    xpath=//*[@id="page"]/div[2]/div[2]/div/div/div[2]/div/div/div/div/div/div[3]/div[1]/div
    Wait Until Element Is Visible    id:article-form
    คลิกเพิ่มสินค้า    ${จำนวน} - 1
    Wait Until Element Is Visible     name:order_count
    Element Attribute Value Should Be    name:order_count    attribute=value    expected=${จำนวน}    
    Click Button    class:btn-addtocart

ตรวจสอบจำนวนสินค้าในตะกร้า
   [Arguments]    ${จำนวน}
    Wait Until Element Is Visible    class:cart-indicator
    Element Should Contain    class:cart-indicator    ${จำนวน}   

ตรวจสอบรายการสินค้าในตะกร้าว่ามีสินค้า
    [Arguments]    ${ชื่อสินค้า}    ${จำนวน}    ${ราคารวม}
    Wait Until Element Is Visible    //*[@id="mini-basket-val"]
    Click Element    //*[@id="mini-basket-val"]
    Wait Until Element Is Visible    id:basket-flyout-items
    Element Should Contain    xpath=//*[@id="basket-flyout-items"]/div/div[2]/div[1]    ${ชื่อสินค้า}
    Element Attribute Value Should Be    name:order_count    attribute=value    expected=${จำนวน}
    Element Should Contain    class:item-sum    ${ราคารวม}

ชำระสินค้า เลือกการจัดส่งโดยรับที่ร้าน และเลือกรหัสสาขา
    [Arguments]    ${รหัสสาขา}
    Click Element    class:btn-confirm
    Wait Until Element Is Visible    id:stepModel
    Click Element    class:tab-store
    Click Element    class:store-number-tab
    Wait Until Element Is Visible    class:storenumber-field-wrapper
    Input Text    id:user-storenumber-input    ${รหัสสาขา}
    Click Button    id:btn-check-storenumber


ตรวจสอบที่อยู่เซเว่นอีเลฟเว่นที่ไปรับ เซเว่นอีเลฟเว่น
    [Arguments]    ${เบอร์โทร}    ${รหัสสาขา}    ${สาขา}    ${ที่อยู่}
    Wait Until Element Is Visible    class:address-wrapper
    Element Attribute Value Should Be    id:second-phone-shipping    attribute=value    expected=${เบอร์โทร}
    ${address_text}    Get Text    xpath=//*[@id="store"]/div[2]/div/div[4]/div[3]/div/div/div[2]/span
    Should Contain    ${address_text}    ${รหัสสาขา}
    Should Contain    ${address_text}    ${สาขา}
    Should Contain    ${address_text}    ${ที่อยู่}
    Submit Form    id:stepModel

ดำเนินการชำระเงิน เลือกชำระเงินด้วยบัตรเดบิต
    Wait Until Element Is Visible    id:stepModel
    Click Button    xpath=//*[@id="payment-options"]/div[1]/button
    Wait Until Element Is Visible    id:COUNTERSERVICE_CC-tab
    
ตรวจสอบสรุปรายการสั่งซื้อสินค้า
    [Arguments]    ${ชื่อผู้ใช้งาน}    ${เบอร์โทร}    ${รหัสสาขา}    ${สาขา}    ${ที่อยู่}    ${ชื่อสินค้า}    ${จำนวน}    ${ราคา}    ${ราคารวม}    ${ค่าจัดส่ง}    ${ยอดสุทธิ}    ${คะแนนAllMenber}
    Element Should Contain    class:invoice-address-wrapper    ${ชื่อผู้ใช้งาน}
    Element Should Contain    class:address    ${เบอร์โทร}
    ${address_text}    Get Text    xpath=//*[@id="stepModel"]/div[1]/div[2]/div[2]/table/tbody[1]/tr[1]/td/div[2]/span
    Should Contain    ${address_text}    ${รหัสสาขา}
    Should Contain    ${address_text}    ${สาขา}
    Should Contain    ${address_text}    ${ที่อยู่}
    Click Element    class:add-position
    Element Should Contain    xpath=//*[@id="stepModel"]/div[1]/div[2]/div[2]/table/tbody[1]/tr[3]/td[2]    ${ชื่อสินค้า}
    Element Should Contain    xpath=//*[@id="stepModel"]/div[1]/div[2]/div[2]/table/tbody[1]/tr[3]/td[3]    ${จำนวน}
    Element Should Contain    xpath=//*[@id="stepModel"]/div[1]/div[2]/div[2]/table/tbody[1]/tr[3]/td[4]    ${ราคา}
    Element Should Contain    xpath=//*[@id="js-invoice-details-tbody"]/tr[1]/td[2]/b    ${ราคารวม}
    Element Should Contain    xpath=//*[@id="js-invoice-details-tbody"]/tr[2]/td[2]/b    ${ค่าจัดส่ง}
    Element Should Contain    id:totalAmount   ${ยอดสุทธิ}
    Element Should Contain    xpath=//*[@id="js-invoice-details-tbody"]/tr[17]/td[2]/b   ${คะแนนAllMenber}

    


    
    

    
