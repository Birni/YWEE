-- MySQL Script generated by Daniel Tatzel with MySQL Workbench
-- Do 12 Jun 2014 21:25:01 CEST
-- Model: New Model    Version: 1.0
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema DB1695063
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `DB1695063` ;
CREATE SCHEMA IF NOT EXISTS `DB1695063` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `DB1695063` ;

-- -----------------------------------------------------
-- Table `DB1695063`.`mitglieder`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DB1695063`.`mitglieder` ;

CREATE TABLE IF NOT EXISTS `DB1695063`.`mitglieder` (
  `benutzername` VARCHAR(20) NOT NULL,
  `geschlecht` INT NOT NULL,
  `vorname` VARCHAR(45) NOT NULL,
  `nachname` VARCHAR(45) NOT NULL,
  `geburtsdatum` DATE NOT NULL,
  `plz` VARCHAR(5) NOT NULL,
  `wohnort` VARCHAR(45) NOT NULL,
  `strasse` VARCHAR(45) NOT NULL,
  `hausnummer` INT UNSIGNED NOT NULL,
  `hnrzusatz` VARCHAR(20) NULL,
  `email` VARCHAR(45) NOT NULL,
  `telefon` VARCHAR(15) NOT NULL,
  `sprache` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`benutzername`),
  INDEX `Wohnort` (`wohnort` ASC))
ENGINE = InnoDB
COMMENT = 'Enthält alle persönlichen Daten eines jeden Mitglieds';


-- -----------------------------------------------------
-- Table `DB1695063`.`gaestebuch`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DB1695063`.`gaestebuch` ;

CREATE TABLE IF NOT EXISTS `DB1695063`.`gaestebuch` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `benutzername` VARCHAR(45) NOT NULL,
  `eintrag` TEXT NOT NULL,
  `autorisiert` INT UNSIGNED NOT NULL,
  INDEX `aut` USING BTREE (`autorisiert` ASC)  COMMENT 'Zum schnellen Filtern von unautorisierten Nachrichten',
  PRIMARY KEY (`id`),
  INDEX `fk_gaestebuch_mitglieder1_idx` (`benutzername` ASC),
  CONSTRAINT `fk_gaestebuch_mitglieder1`
    FOREIGN KEY (`benutzername`)
    REFERENCES `DB1695063`.`mitglieder` (`benutzername`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Enthält alle Autorisierten und Unautorisierten Gästebucheinträge';


-- -----------------------------------------------------
-- Table `DB1695063`.`login`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DB1695063`.`login` ;

CREATE TABLE IF NOT EXISTS `DB1695063`.`login` (
  `benutzername` VARCHAR(20) NOT NULL,
  `passwort` VARCHAR(32) NOT NULL,
  `rolle` INT NOT NULL COMMENT '1: Admin;' /* comment truncated */ /*2: Nutzer*/,
  PRIMARY KEY (`benutzername`),
  INDEX `Rolle` (`rolle` ASC),
  CONSTRAINT `fk_login_mitglieder1`
    FOREIGN KEY (`benutzername`)
    REFERENCES `DB1695063`.`mitglieder` (`benutzername`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Enthält die Benutzernamen und Passwörter (in MD5)';


-- -----------------------------------------------------
-- Table `DB1695063`.`besucherzaehler`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DB1695063`.`besucherzaehler` ;

CREATE TABLE IF NOT EXISTS `DB1695063`.`besucherzaehler` (
  `zaehler` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`zaehler`))
ENGINE = InnoDB
COMMENT = 'Besucherzähler';


-- -----------------------------------------------------
-- Table `DB1695063`.`tutoren`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DB1695063`.`tutoren` ;

CREATE TABLE IF NOT EXISTS `DB1695063`.`tutoren` (
  `benutzername` VARCHAR(20) NOT NULL,
  `umkreis` INT UNSIGNED NOT NULL,
  `stundenlohn` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`benutzername`),
  CONSTRAINT `fk_tutoren_mitglieder1`
    FOREIGN KEY (`benutzername`)
    REFERENCES `DB1695063`.`mitglieder` (`benutzername`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Tutoren samt Informationen.';


-- -----------------------------------------------------
-- Table `DB1695063`.`leistung`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DB1695063`.`leistung` ;

CREATE TABLE IF NOT EXISTS `DB1695063`.`leistung` (
  `benutzername` VARCHAR(20) NOT NULL,
  `fach` VARCHAR(30) NOT NULL,
  `stufen` INT UNSIGNED NOT NULL COMMENT '0 = Alle Stufen',
  PRIMARY KEY (`benutzername`, `fach`, `stufen`),
  CONSTRAINT `fk_leistung_tutoren1`
    FOREIGN KEY (`benutzername`)
    REFERENCES `DB1695063`.`tutoren` (`benutzername`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Enthält die Leistungen eines Tutors.';


-- -----------------------------------------------------
-- Table `DB1695063`.`news`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DB1695063`.`news` ;

CREATE TABLE IF NOT EXISTS `DB1695063`.`news` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `benutzername` VARCHAR(20) NOT NULL,
  `zeit` DATE NOT NULL,
  `nachricht` TEXT NOT NULL,
  `betreff` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'Newsticker';


-- -----------------------------------------------------
-- Table `DB1695063`.`abrechnungen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DB1695063`.`abrechnungen` ;

CREATE TABLE IF NOT EXISTS `DB1695063`.`abrechnungen` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `benutzername` VARCHAR(20) NOT NULL,
  `kreditkartennummer` VARCHAR(16) NOT NULL,
  `ablaufdatum` DATE NOT NULL,
  `pruefziffer` VARCHAR(4) NOT NULL,
  `betrag` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_abrechnungen_mitglieder1_idx` (`benutzername` ASC),
  CONSTRAINT `fk_abrechnungen_mitglieder1`
    FOREIGN KEY (`benutzername`)
    REFERENCES `DB1695063`.`mitglieder` (`benutzername`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Enthält alle auszuführenden Zahlungen.';


USE `DB1695063` ;

-- -----------------------------------------------------
-- View `DB1695063`.`suche`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `DB1695063`.`suche` ;
DROP TABLE IF EXISTS `DB1695063`.`suche`;
USE `DB1695063`;
CREATE  OR REPLACE VIEW `suche` AS 
	(select  m.benutzername, m.Wohnort, t.umkreis, t.stundenlohn, l.fach, l.stufen 
		from tutoren t join leistung l join mitglieder m 
			on m.benutzername = t.benutzername and m.benutzername = l.benutzername);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `DB1695063`.`mitglieder`
-- -----------------------------------------------------
START TRANSACTION;
USE `DB1695063`;
INSERT INTO `DB1695063`.`mitglieder` (`benutzername`, `geschlecht`, `vorname`, `nachname`, `geburtsdatum`, `plz`, `wohnort`, `strasse`, `hausnummer`, `hnrzusatz`, `email`, `telefon`, `sprache`) VALUES ('admin', 1, 'Daniel', 'Irgendeiner', '2000-01-01', '12345', 'Gotham', 'Irgendeine', 1, '0', 'admin@spam.de', '123456', 'de');
INSERT INTO `DB1695063`.`mitglieder` (`benutzername`, `geschlecht`, `vorname`, `nachname`, `geburtsdatum`, `plz`, `wohnort`, `strasse`, `hausnummer`, `hnrzusatz`, `email`, `telefon`, `sprache`) VALUES ('batman', 1, 'Bruce', 'Wayne', '1969-07-03', '12345', 'Gotham', 'Bat-weg', 1, '0', 'batman@wayne.de', '0900-batman', 'de');
INSERT INTO `DB1695063`.`mitglieder` (`benutzername`, `geschlecht`, `vorname`, `nachname`, `geburtsdatum`, `plz`, `wohnort`, `strasse`, `hausnummer`, `hnrzusatz`, `email`, `telefon`, `sprache`) VALUES ('superman', 1, 'Clark', 'Kent', '1973-12-10', '54321', 'Berlin', 'Maisweg', 7, '0', 'clark.kent@kryptonite.com', '51238123', 'en');
INSERT INTO `DB1695063`.`mitglieder` (`benutzername`, `geschlecht`, `vorname`, `nachname`, `geburtsdatum`, `plz`, `wohnort`, `strasse`, `hausnummer`, `hnrzusatz`, `email`, `telefon`, `sprache`) VALUES ('heisenberg', 1, 'Walter', 'White', '1978-07-31', '34493', 'Regensburg', 'Fischmarkt', 123, 'b', 'walter@white.com', '234691237', 'en');
INSERT INTO `DB1695063`.`mitglieder` (`benutzername`, `geschlecht`, `vorname`, `nachname`, `geburtsdatum`, `plz`, `wohnort`, `strasse`, `hausnummer`, `hnrzusatz`, `email`, `telefon`, `sprache`) VALUES ('Robin', 1, 'Robin', 'Sidekick', '1983-03-23', '64573', 'Regensburg', 'Fischkutterstr', 12, 'b', 'robin@sidekick.net', '334562245', 'de');
INSERT INTO `DB1695063`.`mitglieder` (`benutzername`, `geschlecht`, `vorname`, `nachname`, `geburtsdatum`, `plz`, `wohnort`, `strasse`, `hausnummer`, `hnrzusatz`, `email`, `telefon`, `sprache`) VALUES ('Brain', 1, 'Robert', 'Einstein', '1991-02-16', '28314', 'Hinterdupfing', 'Hinterdupfing', 3, '0', 'robert@brain.de', '959382376', 'de');
INSERT INTO `DB1695063`.`mitglieder` (`benutzername`, `geschlecht`, `vorname`, `nachname`, `geburtsdatum`, `plz`, `wohnort`, `strasse`, `hausnummer`, `hnrzusatz`, `email`, `telefon`, `sprache`) VALUES ('Pinky', 0, 'Claire', 'Grube', '1995-05-13', '25982', 'Berlin', 'Bismarkstr', 25, 'a', 'pinky@1und1gleich3.de', '32895328', 'de');
INSERT INTO `DB1695063`.`mitglieder` (`benutzername`, `geschlecht`, `vorname`, `nachname`, `geburtsdatum`, `plz`, `wohnort`, `strasse`, `hausnummer`, `hnrzusatz`, `email`, `telefon`, `sprache`) VALUES ('kitty', 0, 'Susi', 'Maier', '1998-08-03', '35674', 'Regensburg', 'Berlinerstraße', 126, 'd', 'kitty@cat.com', '29823462', 'de');
INSERT INTO `DB1695063`.`mitglieder` (`benutzername`, `geschlecht`, `vorname`, `nachname`, `geburtsdatum`, `plz`, `wohnort`, `strasse`, `hausnummer`, `hnrzusatz`, `email`, `telefon`, `sprache`) VALUES ('Anita', 0, 'Anita', 'Kohl', '1984-10-11', '42389', 'Regensburg', 'Universitätsstr', 31, '0', 'anita@othr.de', '32487523', 'de');
INSERT INTO `DB1695063`.`mitglieder` (`benutzername`, `geschlecht`, `vorname`, `nachname`, `geburtsdatum`, `plz`, `wohnort`, `strasse`, `hausnummer`, `hnrzusatz`, `email`, `telefon`, `sprache`) VALUES ('Alucard', 1, 'Vlad', 'Dracula', '1431-05-27', '89345', 'Berlin', 'Stettiner Straße', 23, 'c', 'vlad@pfaehler.eu', '923042378', 'de');
INSERT INTO `DB1695063`.`mitglieder` (`benutzername`, `geschlecht`, `vorname`, `nachname`, `geburtsdatum`, `plz`, `wohnort`, `strasse`, `hausnummer`, `hnrzusatz`, `email`, `telefon`, `sprache`) VALUES ('humus', 0, 'Steffi', 'Lustig', '1976-11-01', '02516', 'Berlin', 'Leopoldstraße', 204, '0', 'humus@garten.de', '902348764', 'de');
INSERT INTO `DB1695063`.`mitglieder` (`benutzername`, `geschlecht`, `vorname`, `nachname`, `geburtsdatum`, `plz`, `wohnort`, `strasse`, `hausnummer`, `hnrzusatz`, `email`, `telefon`, `sprache`) VALUES ('IQ0', 0, 'Jane', 'Doe', '1956-08-31', '98457', 'Regensburg', 'Landshuterstraße', 12, 'e', 'jane@doe.de', '487234637', 'en');
INSERT INTO `DB1695063`.`mitglieder` (`benutzername`, `geschlecht`, `vorname`, `nachname`, `geburtsdatum`, `plz`, `wohnort`, `strasse`, `hausnummer`, `hnrzusatz`, `email`, `telefon`, `sprache`) VALUES ('Rambo', 1, 'John', 'Doe', '1961-09-05', '09345', 'Berlin', 'Odeonsplatz', 5, '0', 'john@rambo.de', '892346329', 'de');
INSERT INTO `DB1695063`.`mitglieder` (`benutzername`, `geschlecht`, `vorname`, `nachname`, `geburtsdatum`, `plz`, `wohnort`, `strasse`, `hausnummer`, `hnrzusatz`, `email`, `telefon`, `sprache`) VALUES ('Angie', 0, 'Angela', 'Merkel', '1957-07-17', '28975', 'Landshut', 'Rottenburgerstr', 13, '0', 'angie@kanzler.de', '892346786', 'de');
INSERT INTO `DB1695063`.`mitglieder` (`benutzername`, `geschlecht`, `vorname`, `nachname`, `geburtsdatum`, `plz`, `wohnort`, `strasse`, `hausnummer`, `hnrzusatz`, `email`, `telefon`, `sprache`) VALUES ('Catwoman', 0, 'Sandy', 'Kennedy', '1994-03-13', '93457', 'Landshut', 'Tal', 15, '0', 'catwoman@litter.de', '73623134', 'de');
INSERT INTO `DB1695063`.`mitglieder` (`benutzername`, `geschlecht`, `vorname`, `nachname`, `geburtsdatum`, `plz`, `wohnort`, `strasse`, `hausnummer`, `hnrzusatz`, `email`, `telefon`, `sprache`) VALUES ('Kurzschluss', 0, 'Sandra', 'Huber', '1992-09-30', '23487', 'Landshut', 'Weststr', 23, '0', 'sandra@huber.de', '57418666', 'de');
INSERT INTO `DB1695063`.`mitglieder` (`benutzername`, `geschlecht`, `vorname`, `nachname`, `geburtsdatum`, `plz`, `wohnort`, `strasse`, `hausnummer`, `hnrzusatz`, `email`, `telefon`, `sprache`) VALUES ('Snowball', 0, 'Lisa', 'Meier', '1989-11-29', '23464', 'Landshut', 'Killermannstr', 45, '0', 'lisa@meier.net', '38715698', 'de');
INSERT INTO `DB1695063`.`mitglieder` (`benutzername`, `geschlecht`, `vorname`, `nachname`, `geburtsdatum`, `plz`, `wohnort`, `strasse`, `hausnummer`, `hnrzusatz`, `email`, `telefon`, `sprache`) VALUES ('Schafkopf', 1, 'Josef', 'Wenz', '1990-02-28', '23454', 'Landshut', 'Hundsumkehr', 23, 'f', 'josef@wenz.de', '68765135', 'de');
INSERT INTO `DB1695063`.`mitglieder` (`benutzername`, `geschlecht`, `vorname`, `nachname`, `geburtsdatum`, `plz`, `wohnort`, `strasse`, `hausnummer`, `hnrzusatz`, `email`, `telefon`, `sprache`) VALUES ('Superwoman', 0, 'Jaqueline', 'Mayer', '1991-04-01', '23432', 'Regensburg', 'Karl-Stieler-Str', 42, '0', 'jaquie@mayer.eu', '7169645', 'en');
INSERT INTO `DB1695063`.`mitglieder` (`benutzername`, `geschlecht`, `vorname`, `nachname`, `geburtsdatum`, `plz`, `wohnort`, `strasse`, `hausnummer`, `hnrzusatz`, `email`, `telefon`, `sprache`) VALUES ('Ratiopharm', 0, 'Ratio', 'Pharm', '2000-01-01', '12345', 'Pharm', 'Pharmweg', 1, '0', 'ratio@pharm.com', '123456789', 'de');
INSERT INTO `DB1695063`.`mitglieder` (`benutzername`, `geschlecht`, `vorname`, `nachname`, `geburtsdatum`, `plz`, `wohnort`, `strasse`, `hausnummer`, `hnrzusatz`, `email`, `telefon`, `sprache`) VALUES ('h4x0r', 0, '1337', 'h4x0r', '1999-01-01', '12345', 'h4x0rtown', '1337weg', 1, '0', '1337@h4x0r.com', '123456', 'de');

COMMIT;


-- -----------------------------------------------------
-- Data for table `DB1695063`.`gaestebuch`
-- -----------------------------------------------------
START TRANSACTION;
USE `DB1695063`;
INSERT INTO `DB1695063`.`gaestebuch` (`id`, `benutzername`, `eintrag`, `autorisiert`) VALUES (1, 'Robin', 'Dank Die Tutoren Agentur hat sich meine Note in Deutsch von einer 5 auf eine 2 verbessert', 1);
INSERT INTO `DB1695063`.`gaestebuch` (`id`, `benutzername`, `eintrag`, `autorisiert`) VALUES (2, 'humus', 'Dank Die Tutoren Agentur kann mein Sohn jetzt auch bis 10 zählen', 1);
INSERT INTO `DB1695063`.`gaestebuch` (`id`, `benutzername`, `eintrag`, `autorisiert`) VALUES (3, 'Anita', 'Ich kann meinen Namen jetzt auch schreiben', 2);
INSERT INTO `DB1695063`.`gaestebuch` (`id`, `benutzername`, `eintrag`, `autorisiert`) VALUES (4, 'Snowball', 'Sau geile Seite habt ihr da!', 1);
INSERT INTO `DB1695063`.`gaestebuch` (`id`, `benutzername`, `eintrag`, `autorisiert`) VALUES (5, 'Kurzschluss', 'Totaler Schrott, es gibt keinen in meinem Dorf!', 0);
INSERT INTO `DB1695063`.`gaestebuch` (`id`, `benutzername`, `eintrag`, `autorisiert`) VALUES (6, 'Alucard', 'Ich werde es jedem meiner Freunde weiterempfehlen!', 2);
INSERT INTO `DB1695063`.`gaestebuch` (`id`, `benutzername`, `eintrag`, `autorisiert`) VALUES (7, 'IQ0', 'Der letzte Tutor konnte weniger als ich, nie wieder!', 0);
INSERT INTO `DB1695063`.`gaestebuch` (`id`, `benutzername`, `eintrag`, `autorisiert`) VALUES (8, 'Angie', 'Einfach nur genial!', 1);
INSERT INTO `DB1695063`.`gaestebuch` (`id`, `benutzername`, `eintrag`, `autorisiert`) VALUES (9, 'Pinky', 'So schnell hab ich noch nie einen passenden Tutor gefunden, danke!', 2);
INSERT INTO `DB1695063`.`gaestebuch` (`id`, `benutzername`, `eintrag`, `autorisiert`) VALUES (10, 'h4x0r', 'Spam Attack! hihih', 0);
INSERT INTO `DB1695063`.`gaestebuch` (`id`, `benutzername`, `eintrag`, `autorisiert`) VALUES (11, 'Superwoman', 'Toller Dienst und dann auch noch komplett kostenlos! Echt Super!', 2);
INSERT INTO `DB1695063`.`gaestebuch` (`id`, `benutzername`, `eintrag`, `autorisiert`) VALUES (12, 'heisenberg', 'Was will man mehr!', 1);
INSERT INTO `DB1695063`.`gaestebuch` (`id`, `benutzername`, `eintrag`, `autorisiert`) VALUES (13, 'Schafkopf', 'Besser als alle anderen Seiten, diese Begeisterungsmerkmale hier!!! Der Wahnsinn!', 2);
INSERT INTO `DB1695063`.`gaestebuch` (`id`, `benutzername`, `eintrag`, `autorisiert`) VALUES (14, 'Angie', 'Ich komme immer wieder gerne!', 1);
INSERT INTO `DB1695063`.`gaestebuch` (`id`, `benutzername`, `eintrag`, `autorisiert`) VALUES (15, 'Ratiopharm', 'Kaufen Sie jetzt Viagra auf www.viagra-fuer-dich.de sie werden es nicht bereuen!', 0);
INSERT INTO `DB1695063`.`gaestebuch` (`id`, `benutzername`, `eintrag`, `autorisiert`) VALUES (16, 'Rambo', 'Das ist schlicht und ergreifend die beste Seite, das kann man klipp und klar sagen.', 2);
INSERT INTO `DB1695063`.`gaestebuch` (`id`, `benutzername`, `eintrag`, `autorisiert`) VALUES (17, 'Ratiopharm', 'Medikamente zum halben Preis! WOW! Schau auf www.medis-for-half.com vorbei!', 0);
INSERT INTO `DB1695063`.`gaestebuch` (`id`, `benutzername`, `eintrag`, `autorisiert`) VALUES (18, 'Ratiopharm', 'Garantiert ohne Nebenwirkungen, die Hämorrhoiden-creme ihres vertrauens - Hemocreme!', 0);

COMMIT;


-- -----------------------------------------------------
-- Data for table `DB1695063`.`login`
-- -----------------------------------------------------
START TRANSACTION;
USE `DB1695063`;
INSERT INTO `DB1695063`.`login` (`benutzername`, `passwort`, `rolle`) VALUES ('admin', 'e8636ea013e682faf61f56ce1cb1ab5c', 1);
INSERT INTO `DB1695063`.`login` (`benutzername`, `passwort`, `rolle`) VALUES ('batman', 'e8636ea013e682faf61f56ce1cb1ab5c', 1);
INSERT INTO `DB1695063`.`login` (`benutzername`, `passwort`, `rolle`) VALUES ('superman', 'e8636ea013e682faf61f56ce1cb1ab5c', 1);
INSERT INTO `DB1695063`.`login` (`benutzername`, `passwort`, `rolle`) VALUES ('heisenberg', 'e8636ea013e682faf61f56ce1cb1ab5c', 0);
INSERT INTO `DB1695063`.`login` (`benutzername`, `passwort`, `rolle`) VALUES ('Robin', 'e8636ea013e682faf61f56ce1cb1ab5c', 0);
INSERT INTO `DB1695063`.`login` (`benutzername`, `passwort`, `rolle`) VALUES ('Brain', 'e8636ea013e682faf61f56ce1cb1ab5c', 0);
INSERT INTO `DB1695063`.`login` (`benutzername`, `passwort`, `rolle`) VALUES ('Pinky', 'e8636ea013e682faf61f56ce1cb1ab5c', 0);
INSERT INTO `DB1695063`.`login` (`benutzername`, `passwort`, `rolle`) VALUES ('kitty', 'e8636ea013e682faf61f56ce1cb1ab5c', 0);
INSERT INTO `DB1695063`.`login` (`benutzername`, `passwort`, `rolle`) VALUES ('Anita', 'e8636ea013e682faf61f56ce1cb1ab5c', 0);
INSERT INTO `DB1695063`.`login` (`benutzername`, `passwort`, `rolle`) VALUES ('Alucard', 'e8636ea013e682faf61f56ce1cb1ab5c', 0);
INSERT INTO `DB1695063`.`login` (`benutzername`, `passwort`, `rolle`) VALUES ('humus', 'e8636ea013e682faf61f56ce1cb1ab5c', 0);
INSERT INTO `DB1695063`.`login` (`benutzername`, `passwort`, `rolle`) VALUES ('IQ0', 'e8636ea013e682faf61f56ce1cb1ab5c', 0);
INSERT INTO `DB1695063`.`login` (`benutzername`, `passwort`, `rolle`) VALUES ('Rambo', 'e8636ea013e682faf61f56ce1cb1ab5c', 0);
INSERT INTO `DB1695063`.`login` (`benutzername`, `passwort`, `rolle`) VALUES ('Angie', 'e8636ea013e682faf61f56ce1cb1ab5c', 0);
INSERT INTO `DB1695063`.`login` (`benutzername`, `passwort`, `rolle`) VALUES ('Catwoman', 'e8636ea013e682faf61f56ce1cb1ab5c', 0);
INSERT INTO `DB1695063`.`login` (`benutzername`, `passwort`, `rolle`) VALUES ('Kurzschluss', 'e8636ea013e682faf61f56ce1cb1ab5c', 0);
INSERT INTO `DB1695063`.`login` (`benutzername`, `passwort`, `rolle`) VALUES ('Snowball', 'e8636ea013e682faf61f56ce1cb1ab5c', 0);
INSERT INTO `DB1695063`.`login` (`benutzername`, `passwort`, `rolle`) VALUES ('Schafkopf', 'e8636ea013e682faf61f56ce1cb1ab5c', 0);
INSERT INTO `DB1695063`.`login` (`benutzername`, `passwort`, `rolle`) VALUES ('Superwoman', 'e8636ea013e682faf61f56ce1cb1ab5c', 0);
INSERT INTO `DB1695063`.`login` (`benutzername`, `passwort`, `rolle`) VALUES ('Ratiopharm', 'e8636ea013e682faf61f56ce1cb1ab5c', 0);
INSERT INTO `DB1695063`.`login` (`benutzername`, `passwort`, `rolle`) VALUES ('h4x0r', 'e8636ea013e682faf61f56ce1cb1ab5c', 0);

COMMIT;


-- -----------------------------------------------------
-- Data for table `DB1695063`.`besucherzaehler`
-- -----------------------------------------------------
START TRANSACTION;
USE `DB1695063`;
INSERT INTO `DB1695063`.`besucherzaehler` (`zaehler`) VALUES (0);

COMMIT;


-- -----------------------------------------------------
-- Data for table `DB1695063`.`tutoren`
-- -----------------------------------------------------
START TRANSACTION;
USE `DB1695063`;
INSERT INTO `DB1695063`.`tutoren` (`benutzername`, `umkreis`, `stundenlohn`) VALUES ('heisenberg', 10, 20);
INSERT INTO `DB1695063`.`tutoren` (`benutzername`, `umkreis`, `stundenlohn`) VALUES ('superman', 1000, 15);
INSERT INTO `DB1695063`.`tutoren` (`benutzername`, `umkreis`, `stundenlohn`) VALUES ('Brain', 5, 10);
INSERT INTO `DB1695063`.`tutoren` (`benutzername`, `umkreis`, `stundenlohn`) VALUES ('Rambo', 15, 12);
INSERT INTO `DB1695063`.`tutoren` (`benutzername`, `umkreis`, `stundenlohn`) VALUES ('Schafkopf', 7, 14);
INSERT INTO `DB1695063`.`tutoren` (`benutzername`, `umkreis`, `stundenlohn`) VALUES ('Catwoman', 0, 7);
INSERT INTO `DB1695063`.`tutoren` (`benutzername`, `umkreis`, `stundenlohn`) VALUES ('Alucard', 2, 17);
INSERT INTO `DB1695063`.`tutoren` (`benutzername`, `umkreis`, `stundenlohn`) VALUES ('Anita', 0, 5);

COMMIT;


-- -----------------------------------------------------
-- Data for table `DB1695063`.`leistung`
-- -----------------------------------------------------
START TRANSACTION;
USE `DB1695063`;
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('heisenberg', 'Chemie', 8);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('heisenberg', 'Chemie', 9);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('heisenberg', 'Chemie', 10);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('heisenberg', 'Mathe', 5);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('heisenberg', 'Mathe', 6);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('heisenberg', 'Mathe', 7);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Alucard', 'Geschichte', 5);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Alucard', 'Geschichte', 6);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Alucard', 'Geschichte', 7);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Alucard', 'Geschichte', 8);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('superman', 'Physik', 10);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('superman', 'Physik', 11);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('superman', 'Physik', 12);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Brain', 'Deutsch', 5);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Brain', 'Deutsch', 6);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Brain', 'Deutsch', 7);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Brain', 'Deutsch', 8);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Brain', 'Erdkunde', 7);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Brain', 'Erdkunde', 8);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Brain', 'Erdkunde', 9);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Brain', 'Informatik', 5);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Brain', 'Inforamtik', 6);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Brain', 'Biologie', 7);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Schafkopf', 'Wirtschaft', 5);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Schafkopf', 'Wirtschaft', 6);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Schafkopf', 'Wirtschaft', 7);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Schafkopf', 'Englisch', 5);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Schafkopf', 'Mathe', 5);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Rambo', 'Sport', 0);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Rambo', 'Kunst', 0);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Rambo', 'Latein', 0);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Anita', 'Deutsch', 0);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Anita', 'Englisch', 0);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Anita', 'Latein', 0);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Anita', 'Erdkunde', 0);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Catwoman', 'Latein', 0);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Catwoman', 'Wirtschaft', 0);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Catwoman', 'Informatik', 5);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Catwoman', 'Biologie', 5);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Alucard', 'Latein', 7);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Alucard', 'Englisch', 5);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Alucard', 'Englisch', 6);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Alucard', 'Englisch', 7);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('superman', 'Mathe', 0);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('superman', 'Deutsch', 0);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('heisenberg', 'Deutsch', 0);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Brain', 'wirtschaft', 0);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Alucard', 'Biologie', 7);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Alucard', 'Biologie', 8);
INSERT INTO `DB1695063`.`leistung` (`benutzername`, `fach`, `stufen`) VALUES ('Alucard', 'Biologie', 9);

COMMIT;


-- -----------------------------------------------------
-- Data for table `DB1695063`.`news`
-- -----------------------------------------------------
START TRANSACTION;
USE `DB1695063`;
INSERT INTO `DB1695063`.`news` (`id`, `benutzername`, `zeit`, `nachricht`, `betreff`) VALUES (1, 'admin', '2014-03-18', 'Das erste Treffen fand statt, wir waren dabei!', 'Erste Vermittlung');
INSERT INTO `DB1695063`.`news` (`id`, `benutzername`, `zeit`, `nachricht`, `betreff`) VALUES (2, 'admin', '2014-03-25', 'Wir haben eine neue Zentrale, besuchen Sie uns!', 'Neue Zentrale');
INSERT INTO `DB1695063`.`news` (`id`, `benutzername`, `zeit`, `nachricht`, `betreff`) VALUES (3, 'admin', '2014-04-01', 'Ab heute haben wir 10 Mitglieder, danke an alle!', 'WOW 10 Mitglieder!');
INSERT INTO `DB1695063`.`news` (`id`, `benutzername`, `zeit`, `nachricht`, `betreff`) VALUES (4, 'admin', '2014-04-10', 'Durch die Tutoren AG hat sich der Notendurchschnitt in Deutschland  um 3 Noten verbessert!', 'Deutschland wird intelligenter');
INSERT INTO `DB1695063`.`news` (`id`, `benutzername`, `zeit`, `nachricht`, `betreff`) VALUES (5, 'admin', '2014-04-29', 'Gewinnt eine von sechs Bleistiften, schreibt dem admin eine Mail!', 'Mega Gewinnspiel');
INSERT INTO `DB1695063`.`news` (`id`, `benutzername`, `zeit`, `nachricht`, `betreff`) VALUES (6, 'admin', '2014-05-17', 'Die Gewinner wurden ausgelost und beachrichtigt.', 'Ende des Gewinnspiels');
INSERT INTO `DB1695063`.`news` (`id`, `benutzername`, `zeit`, `nachricht`, `betreff`) VALUES (7, 'admin', '2014-05-30', 'Unsere Seite gibt es jetzt teilweise auch auf Englisch!', 'Englische Seiten');
INSERT INTO `DB1695063`.`news` (`id`, `benutzername`, `zeit`, `nachricht`, `betreff`) VALUES (8, 'admin', '2014-06-01', 'Profile kann man jetzt auch löschen, auch wenn ihr das nicht wollt!', 'Verlassen der Tutoren AG ist jetzt möglich');
INSERT INTO `DB1695063`.`news` (`id`, `benutzername`, `zeit`, `nachricht`, `betreff`) VALUES (9, 'admin', '2014-06-05', 'Ihr findet nun im rechten Balken ein tolles Video!', 'Video auf der Seite');
INSERT INTO `DB1695063`.`news` (`id`, `benutzername`, `zeit`, `nachricht`, `betreff`) VALUES (10, 'admin', '2014-06-11', 'Spendet uns Geld oder wir werden nicht weiter existieren können!', 'Spendenaufruf');

COMMIT;


-- -----------------------------------------------------
-- Data for table `DB1695063`.`abrechnungen`
-- -----------------------------------------------------
START TRANSACTION;
USE `DB1695063`;
INSERT INTO `DB1695063`.`abrechnungen` (`id`, `benutzername`, `kreditkartennummer`, `ablaufdatum`, `pruefziffer`, `betrag`) VALUES (1, 'batman', '6238340249502934', '2014-06-31', '391', 100);
INSERT INTO `DB1695063`.`abrechnungen` (`id`, `benutzername`, `kreditkartennummer`, `ablaufdatum`, `pruefziffer`, `betrag`) VALUES (2, 'kitty', '9036723860285769', '2017-05-31', '347', 50);
INSERT INTO `DB1695063`.`abrechnungen` (`id`, `benutzername`, `kreditkartennummer`, `ablaufdatum`, `pruefziffer`, `betrag`) VALUES (3, 'Rambo', '1209473456834096', '2019-03-31', '593', 70);
INSERT INTO `DB1695063`.`abrechnungen` (`id`, `benutzername`, `kreditkartennummer`, `ablaufdatum`, `pruefziffer`, `betrag`) VALUES (4, 'IQ0', '9075483457504257', '2015-09-31', '954', 10);

COMMIT;

