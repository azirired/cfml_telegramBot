
<cfif #Qselect.recordcount# GT 0>
	<cfquery name="Qupdate" datasource="#dsn#">
		UPDATE tbl_commandPos
			SET  
				tkh_state=#now()#,
				commandTxt='PAMER',
				uuidPos='#uuidPos#'
			WHERE telegram_id=#aa.chat.id#
	
	</cfquery>

<cfelseif #Qselect.recordcount# EQ 0>
	<cfquery name="Qtemp" datasource="#dsn#">
		insert into tbl_commandPos(
				telegram_id,
				tkh_state,
				commandTxt,
				uuidPos

			) values (
				'#aa.chat.id#',
				#now()#, 
				'PAMER',
				'#uuidPos#'
			)
	
	</cfquery>
</cfif>


<cfset txt="Masukkan tarikh temujanji yang ingin dipamerkan:">
<cfhttp url="#urlTelegram##token#/sendMessage?chat_id=#aa.from.id#&text=#txt#&reply_markup=#buttonTarikh#">