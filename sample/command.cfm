


<cfset uuidPos=#createUUID()#>

<!---check dalam tbl_commandPos--->
<cfquery name="Qselect" datasource="#dsn#">
		SELECT *
	from tbl_commandPos
	WHERE telegram_id= <cfqueryparam cfsqltype="cf_sql_varchar" value="#aa.chat.id#">
</cfquery>


<cfif #aa.text# EQ "/daftar">

	<cfif #Qselect.recordcount# GT 0>
		<cfquery name="Qupdate" datasource="#dsn#">
			
				UPDATE tbl_commandPos
				SET  
					tkh_state=#now()#,
					commandTxt='DAFTAR',
					uuidPos='#uuidPos#',
					temptxt=''
				WHERE telegram_id=#aa.chat.id#
		
		</cfquery>

	<cfelseif #Qselect.recordcount# EQ 0>
		<cfquery name="Qtemp" datasource="#dsn#">
			insert into tbl_commandPos(
					telegram_id,
					tkh_state,
					commandTxt,
					uuidPos,
					temptxt

				) values (
					'#aa.chat.id#',
					#now()#,
					'DAFTAR',
					'#uuidPos#',
					''
				)
		
		</cfquery>
	</cfif>


	<cfhttp url="#urlTelegram##token#/sendMessage?chat_id=#aa.from.id#&text=Masukkan no IC">
    
<cfelseif #aa.text# EQ "/menu">
	<cfhttp url="#urlTelegram##token#/sendMessage?chat_id=#aa.from.id#&text=Selamat Datang #aa.from.username#&reply_markup=#buttonMenu#">


<!---button temujanji--->
<cfelseif #aa.text# EQ "/temujanji">
	<cfinclude template="temujanji.cfm">

<!---button pamer--->
<cfelseif #aa.text# EQ "/pamer">
	<cfinclude template="pamer.cfm">	

<cfelseif #aa.text# EQ "/permohonan">
	<cfinclude template="permohonan.cfm">

<cfelseif #trim(left(aa.text,16))# EQ "Lulus Permohonan">
	<cfset arrPermohonan = listToArray(aa.text,":")>
	<cfset uuidProses=#trim(arrPermohonan[2])#>

	<cfquery name="Qproses" datasource="#dsn#">
		SELECT * 
		FROM tbl_permohonan
		WHERE uuid = '#uuidProses#'
	</cfquery>

	<cfloop query="Qproses">
		<cfquery datasource="#dsn#" name="Qupdate">
			UPDATE tbl_permohonan
			SET  
				kelulusan=1,
				tarikh_lulus=#now()#
			WHERE uuid='#uuidProses#'
		</cfquery>

	</cfloop>

	<cfhttp url="#urlTelegram##token#/sendMessage?chat_id=#aa.from.id#&text=Kelulusan telah dihantar ke User &reply_markup=#buttonMenu#">

<cfelseif #trim(left(aa.text,22))# EQ "Tidak Lulus Permohonan">
	<cfset arrPermohonan = listToArray(aa.text,":")>
	<cfset uuidProses=#arrPermohonan[2]#>

	<cfquery name="Qproses" datasource="#dsn#">
		SELECT * 
		FROM tbl_permohonan
		WHERE uuid = '#uuidProses#'
	</cfquery>
	
	<cfloop query="Qproses">
		<cfquery datasource="#dsn#" name="Qupdate">
			UPDATE tbl_permohonan
			SET  
				kelulusan=2,
				tarikh_lulus=#now()#
			WHERE uuid=#uuidProses#
		</cfquery>

	</cfloop>
<cfelse>
	<cfinclude template="command2.cfm">
	
</cfif>