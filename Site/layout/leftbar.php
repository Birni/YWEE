<div id="wrapper"> 

<div id="left">

    <noscript>
        <br><b>Sie haben Javascript nicht aktiviert. Aktivieren sie Javascript um unsere Seite im vollen Umfang nutzen zu k&ouml;nnen!</b><br>
    </noscript>
    
    <?php
        /* Grundgeruest fuer Sprachauswahl
        if ( $_SESSION['sprache'] == "en" )
            echo "Englisch";
        else
            echo "Deutsch";
        */
        
        include_once($_SERVER["DOCUMENT_ROOT"] . "/test_02/scripts/ReadTopGuestbook.php");       // Inkludiert die Top Gaestebucheintraege
        
        echo "<br>";
        
        if ( $_SESSION['admin'] == true )
        {
            echo "Counter: ";
            include_once($_SERVER["DOCUMENT_ROOT"] . "/test_02/scripts/GetCounterValue.php"); // Inkludiert die Counter Abfrage
        }
    ?>
    
	<!----------Block for Map by Matthias Birnthaler ----------------->
	<?php
	
	if ( $_SESSION['sprache'] == "en" )
            {
                echo '<div class="basic-wrapper-top">
						Guestbook </div>';      
            }
            else
            {
                echo '<div class="basic-wrapper-top">
						Gästebuch</div>';
			}
	?>
	 
	<div class="basic-wrapper-middle">
	<br>
	placeholder für Gästebuch
	<br>
	<br>
	<hr class="lane">
	</div>
	
	
	<div class="basic-wrapper-middle">
	<br>
	Inhalt steht zum Anschaun im leftbar.php (uncool) 
	<br>
	<br>
	<hr class="lane">
	</div>
	
	<div class="basic-wrapper-middle">
	<br>
	des kann muss noch irgendwer hinbiegen
	<br>
	<br>
	<hr class="lane">
	</div>
	
	<div class="basic-wrapper-middle"> <!-- middle item-->
	<br>
	ich nicht ich bin fürs layout da 
	<br>
	<br>
	<hr class="lane">
	</div>
	
	<div class="basic-wrapper-middle">
	<br>
	nutz mein layout 
	<br>
	<br>
	<hr class="lane">
	</div>
	
	<div class="basic-wrapper-bottom"> <!--last item- no lane for the last item-->
	<br>
	ich würde nicht läger gehen als die rechte spalte (scrollbalken oder max Einträge!) 
	</div
	
	
	
	
	
	
	
	
	
	</p>
</div>
