
<meta http-equiv="refresh" content="2">

<h3>I'm alive!!!</h3>
<cfoutput>#now()#</cfoutput>

<cfinclude template="_init.cfm">
<cfparam name="offset" default="0">

<cfhttp url="#urlTelegram##token#/getUpdates?offset=#offset#" result="abc">

<cffile  
    action = "read"  
    file = "#expandPath("./last_read.txt")#" 
    variable = "last_id">

	<cfset offset=#last_id#+1>
    

<!--- #1 Get telegram bot JSON--->
<!---call command telegram updates--->
    
    <cfhttp
	url="https://api.telegram.org/bot#token#/getupdates?offset=#offset#"
    result="jsonText" />


 <!---baca & pecahkan format json--->
<cfset jsonData = deserializeJSON(jsonText.fileContent) />
<!---cfdump var="#jsonData#"--->

<!--- Check we have records returned to us --->
<cfif arrayLen(jsonData.result)>

	<!--- We want to provide the query with column names --->
	<cfset strColType        =    '' />
    <!--- To do this, we'll take the first result item... --->
    <cfset stuFirstArrJSON     =     jsonData.result[1] />
    <!--- and get the list of keys from the structure. --->
	<cfset thisKeyList         =     structKeyList(stuFirstArrJSON) />
    
    <!---
        We now need to provide the column data type.
        This example assumes everything is a VarChar.
        Looping over the list of keys, we'll append a
        datatype to the column type list defined earlier.
    --->
    <cfloop list="thisKeyList" index="listItem">
        <cfset listAppend(strColType,'varChar') />
    </cfloop>
    
    <cfset qryTelegram = queryNew(
                            thisKeyList,
                            strColType,
                            jsonData.result
                        ) />
    
        
  
    

    <!---panggil json yang telah diconvert kpd query--->
    <cfoutput query="qryTelegram">

    	<cffile action="write" file="#expandPath("./last_read.txt")#" output="#update_id#">
    	<!---call elemen dalam message--->
    	<cfset aa=#deserializeJSON(SerializeJSON(message))#>
        
        <!---command--->
        <cfinclude template="command.cfm">
            
         
   	</cfoutput>  
    <cfdump var="#qryTelegram#">

</cfif>
