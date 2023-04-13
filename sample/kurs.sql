# MySQL dump 6.8
# Ein Beispiel einer Kurs-Datenbank.
# Es werde verschiedene Kurs-Typen angeboten. Die Realisierung eines Kurses wird Angebot (mit Datum) genannt.
# Die Angebotewerden von Referenten in einem Ort durchgeführt.
# Die Kurse sind hierarchisch strukturiert.
# Also zu Kurstyp A gehören Untertypen A1 A2 A3, etc...
# Zu jedem Kurs kann ein Vorgänger (umgekehrt Nachfolger) genannt werden.
# Z.B die Teilnahme am Kurs B setzt voraus die frühere Teilnahme am Kurs A (B ist Vertiefung von A).
#
# Um dieses Bank anzulegen kreiieren sie zuerst eine leere Datenbank
# >CREATE DATABASE kurs;
# nacher 
# mysql -u user kurs <kurs.sql
#
# Table structure for table 'Angebot'
#
CREATE TABLE Angebot (
  AngebotId int DEFAULT '0' NOT NULL auto_increment,
  Datum date,
  OrtId int DEFAULT '0' NOT NULL,
  KursId int DEFAULT '0' NOT NULL,
  PRIMARY KEY (AngebotId),
  KEY OrtId (OrtId),
  KEY KursId (KursId)
);

#
# Table structure for table 'Kurs'
#
CREATE TABLE Kurs (
  KursId int DEFAULT '0' NOT NULL auto_increment,
  Name varchar(25),
  Zielsetzung text,
  Inhalt text,
  Preis int,
  Dauer int,
  StrukturId int DEFAULT '0' NOT NULL,
  PRIMARY KEY (KursId),
  KEY StrukturId (StrukturId)
);

#
# Table structure for table 'Ort'
#
CREATE TABLE Ort (
  OrtId int DEFAULT '0' NOT NULL auto_increment,
  Name varchar(30),
  Land varchar(20),
  Beschreibung text,
  PRIMARY KEY (OrtId)
);

#
# Table structure for table 'Referent'
#
CREATE TABLE Referent (
  ReferentId int DEFAULT '0' NOT NULL auto_increment,
  Name char(50),
  Titel char(30),
  PRIMARY KEY (ReferentId)
);

#
# Table structure for table 'Struktur'
#
CREATE TABLE Struktur (
  StrukturId int DEFAULT '0' NOT NULL auto_increment,
  Name char(50),
  OberstrukturId int,
  PRIMARY KEY (StrukturId)
);

#
# Table structure for table 'Teilnehmer'
#
CREATE TABLE Teilnehmer (
  TeilnehmerId int DEFAULT '0' NOT NULL auto_increment,
  Anrede enum('Herr','Frau') DEFAULT 'Herr',
  Name varchar(30),
  Vorname varchar(30),
  Firma varchar(50),
  Funktion varchar(40),
  Abteilung varchar(40),
  Strasse_Nr varchar(50),
  PLZ varchar(10),
  Ort varchar(50),
  Telefon varchar(30),
  Fax varchar(30),
  Email varchar(30),
  Bemerkung text,
  PRIMARY KEY (TeilnehmerId)
);

CREATE TABLE liest_vor (
  AngebotId int DEFAULT '0' NOT NULL,
  ReferentId int DEFAULT '0' NOT NULL,
  PRIMARY KEY (AngebotId,ReferentId)
);

#
# Table structure for table 'nimmt_teil'
#
CREATE TABLE nimmt_teil (
  TeilnehmerId int DEFAULT '0' NOT NULL,
  AngebotId int DEFAULT '0' NOT NULL,
  Datum timestamp(14),
  PRIMARY KEY (TeilnehmerId,AngebotId)
);


# Table structure for table 'setzt_voraus'
#
CREATE TABLE setzt_voraus (
  KursId int DEFAULT '0' NOT NULL,
  KursVoraussetzungId int DEFAULT '0' NOT NULL,
  PRIMARY KEY (KursId,KursVoraussetzungId)
);


