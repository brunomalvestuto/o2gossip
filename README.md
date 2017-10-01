# O2Gossip

Information have been transfered over the air in a form of light that humans cannot see. With that in mind, I decided to convert some of that invisible light into light we can see.

An example of that is your wifi at home, every time you got home your smartphone connects to your wifi router, tools such as airodump-ng can read this information which containts  mac addresses from people connected  that can be used to check if your roommate is home.

For that I created O2Gossip, the name is a pun with O2 and Gossip, as the information being transfered over the air may be gossipping about you at the moment. Elixir was used to parse the file output from airodump-ng and then based on a prefined list of mac addresses can send a sign to the relay connecting one light for each of my room mates that then will turn a light on.

Items I used in the project:

* https://www.amazon.co.uk/Foxnovo-Channel-Module-Control-Optocoupler/dp/B00E39RIOK/ref=pd_nav_hcs_bia_t_1?_encoding=UTF8&psc=1&refRID=FPPSPP9JBZJGZSR6TJ7Y 
* https://www.amazon.co.uk/gp/product/B01CSD1X3E/ref=oh_aui_detailpage_o06_s00?ie=UTF8&psc=1
* https://www.amazon.co.uk/gp/product/B00REZPU3G/ref=oh_aui_detailpage_o08_s00?ie=UTF8&psc=1
