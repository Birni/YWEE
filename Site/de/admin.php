<?php

	/*
	 * author: Florian Laufenböck
	 * script for admin-Interface 
	 * 
	 */
	include_once($_SERVER["DOCUMENT_ROOT"] . "/test_02/scripts/session.php");       // Inkludiert die Session	

    $titel = "Allgemeine Gesch&auml;ftsbedingungen"; // Name der Seite die im Browser angezeigt werden soll

    $_SESSION['sprache'] = "de";
    
	include($_SERVER["DOCUMENT_ROOT"] . "/test_02/layout/header.php");   // Inkludiert den Header
	
	if(isset($_SESSION['user']) and ($_SESSION['admin']) and $_SESSION['admin'] == true)
	{
		if($_GET['guestbook'] == true)
		{
			if(isset($_GET['fired']) and $_GET['fired'] == true and isset($_POST["freigaben"]))
			{
				$guestbook_to_change = $_POST["freigaben"];
				include_once($_SERVER["DOCUMENT_ROOT"] . "/test_02/scripts/ChangeGuestbookState.php");
			}
			include_once($_SERVER["DOCUMENT_ROOT"] . "/test_02/scripts/ReadUnauthGuestbook.php");
			$guestbookresults = $result;
			$guestbook_print = "";
			foreach($guestbookresults as $eintrag)
			{
				$guestbook_print .= "<tr> ";
				$guestbook_print .= "<th><div class='UnauthGBEntry'> " . $eintrag["eintrag"] . "</div></th>";
				//todo: ändern des links für den produktiven Einsatz hier und in ShowUnauthGuestbook.html
				$guestbook_print .= "<th><div class='UnauthGBAuthor'> ". $eintrag["benutzername"] . "</div></th> ";
				$guestbook_print .= '<th><div class="UnauthGBCheckbox"><input type="checkbox" name="freigaben[]" value="'. $eintrag["id"] . '"></div></th>';
				$guestbook_print .= "</tr>";
			}
			include_once($_SERVER["DOCUMENT_ROOT"] . "/test_02/de/content/ShowUnauthGuestbook.html");
		}
		if(isset($_GET['deleteUser']) and $_GET['deleteUser'] == true)
		{
			if(isset($_GET['letter']))
			{
				if(isset($_GET['fired']) and ($_GET['fired'] == true) and isset($_POST["deleteUser"]))
				{
					// jetzt soll ein User gelöscht werden
					$deleteUser = $_POST["deleteUser"];
					include_once($_SERVER["DOCUMENT_ROOT"] . "/test_02/scripts/DeleteUserfromAdmin.php");
				}
				$letter_to_take = $_GET['letter'];
				$AllUsersWithThisLetter = "";
				include_once($_SERVER["DOCUMENT_ROOT"] . "/test_02/scripts/ad_GetUsers.php");
				foreach($ad_result as $user)
				{
					$AllUsersWithThisLetter .= "<tr> ";
					$AllUsersWithThisLetter .= "<th>" . "<a href='/de/profile.php?username=" .$user["benutzername"] . "'>".$user["benutzername"] . "</a> </th> ";
					$AllUsersWithThisLetter .= '<th> <input type="checkbox" name="deleteUser[]" value="'. $user["benutzername"] . '"></th>';
					$AllUsersWithThisLetter .= "</tr>";
				}
				include_once($_SERVER["DOCUMENT_ROOT"] . "/test_02/de/content/ad_ShowUsers.html");
			}
			include_once($_SERVER["DOCUMENT_ROOT"] . "/test_02/de/content/ad_GetLetters.html");
		}
		if(isset($_GET['deleteNews']) and $_GET['deleteNews'] == true)
		{
			// Delete News by Alexander Strobl
			if(isset($_GET['fired']) and $_GET['fired'] == true and isset($_POST["NewsID"]))
			{
				$deleteNews = $_POST["NewsID"];
				include_once($_SERVER["DOCUMENT_ROOT"] . "/test_02/scripts/DeleteNewsfromAdmin.php");
			}
			include_once($_SERVER["DOCUMENT_ROOT"] . "/test_02/scripts/ReadNewsDelete.php");
			$newsresults = $result;
			$news_print = "";
			foreach($newsresults as $eintrag)
			{
				$news_print .= "<tr> ";
				$news_print .= "<th><div class='NewsDelEntry'> " . $eintrag["nachricht"] . "</div></th>";
				$news_print .= "<th><div class='NewsDelTopic'> " . $eintrag["betreff"] . "</div></th>";
				$news_print .= "<th><div class='NewsDelAuthor'> ". $eintrag["benutzername"] . "</div></th> ";
				$news_print .= '<th><div class="NewsCheckbox"><input type="checkbox" name="NewsID[]" value="'. $eintrag["id"] . '"></div></th>';
				$news_print .= "</tr>";
			}
			include_once($_SERVER["DOCUMENT_ROOT"] . "/test_02/de/content/ShowNewstoDelete.html");
		}
		if(isset($_GET['unlockUser']) and $_GET['unlockUser'] == true)
		{
			if(isset($_GET['fired']) and ($_GET['fired'] == true) and isset($_POST["UsersToUnlock"]))
			{
				$tounlockUser = $_POST["UsersToUnlock"];
				include_once($_SERVER["DOCUMENT_ROOT"] . "/test_02/scripts/UnlockUsers.php");
			}
			$lockedUsers = "";
			include_once($_SERVER["DOCUMENT_ROOT"] . "/test_02/scripts/ad_GetLockedUsers.php");
			foreach($get_locked_users as $user)
			{
				$lockedUsers .= "<tr> ";
				$lockedUsers .= "<th> <a href='/de/profile.php?username=" .$user["benutzername"] . "'>".$user["benutzername"] . "</a> </th> ";
				$lockedUsers .= '<th> <input type="checkbox" name="UsersToUnlock[]" value="'. $user["benutzername"] . '"></th>';
				$lockedUsers .= "</tr>";
			}
			include_once($_SERVER["DOCUMENT_ROOT"] . "/test_02/de/content/ad_unlockUsers.html");
		}
		include_once($_SERVER["DOCUMENT_ROOT"] . "/test_02/de/content/AdminLanding.html");
	}
	else
		echo "<h2>Fehler! Die aufgerufene Seite existiert nicht oder Sie m&uuml;ssen sich erst einloggen</h2>";
	
	include($_SERVER["DOCUMENT_ROOT"] . "/test_02/layout/footer.php"); // Inkludiert den Footer
?>
