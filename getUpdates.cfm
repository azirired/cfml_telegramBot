<!---
  Contoh bagi kaedah pooling menggunakan getupdates command
  kaedah ini kurang praktikal kerana perlu sentisa onkan
  web browser. 
  Kenapa perlu kaedah ini?
  Bagi mereka yang tiada server https untuk buat kaedah webhook
  --->

<!--- set website untuk refresh setiap 2saat -->
<meta http-equiv="refresh" content="2">

<cfset bot_token = "PUT_YOUR_BOT_TOKEN_HERE">

<!--- 
 offset file -  untuk dapatkan last id message 
 yang dibaca oleh sys. Create satu txt file
 cth: last_read.txt
--->

<cffile  
    action = "read" 
    file = "c:/last_read.txt" 
    variable = "last_id">
    
<!--- tambah satu bagi offset --->
<cfset offset=#last_id#+1>
	
<!--- Buat panggilan ke API --->
<cfoutput>
  <cfhttp 
    url="https://api.telegram.org/bot#bot_token#/getupdates?offset=#offset#"
    method="get"
    result="botMesej" />
</cfoutput>


<!--- Convert JSON to array of structs --->
<cfset jsonData = deserializeJSON(botMesej.fileContent) />

<!--- Semak ada rekod yg dihantar balik --->
<cfif arrayLen(jsonData.result)>
    <!--- Set kolom pada query --->
    <cfset strColType = '' />
    
    <!--- Ambil result dgn menggunakan data kolom pertama --->
    <cfset stuFirstTweet = jsonData.result[1] />
    
    <!--- dapat key --->
    <cfset thisKeyList = structKeyList(stuFirstTweet) />
    
    <!--- looping pada setiap key yang ada --->
    <cfloop list="thisKeyList" index="listItem">
        <cfset listAppend(strColType,'varChar') />
    </cfloop>

    <!--- dari JSON convert ke bentuk query --->
    <cfset qryTweets = queryNew(
                            thisKeyList,
                            strColType,
                            jsonData.result
                        ) />

	<cfoutput query="qryTweets">
		
    <!--- set content supaya pendek dan senang nak call--->
		<cfset aa=#deserializeJSON(SerializeJSON(message))#>
    
    <!-- 
      Start untuk baca arahan yang dihantar
      melalui telegram
      --->
    <cfif #aa.text# is "/hi">
      <cfhttp 
         url="https://api.telegram.org/bot#bot_token#/sendMessage?chat_id=#aa.from.id#&text=Hello">
      </cfhttp>
    </cfif>
    <!-- 
      END : Start untuk baca arahan yang dihantar
      melalui telegram
      --->
	
		<!--- save last message id yang sudah baca --->
		<cffile 
        action = "write"  
        file = "c:/last_read.txt"  
        output = "#update_id#">

	</cfoutput>

</cfif>
