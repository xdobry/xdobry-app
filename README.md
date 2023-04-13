# XDOBRY DB FORM GENERATOR #

Xdobry is free in form-generator for relational databases (mysql, postgresql, sqlite , odbc, Oracle, MS SQL-Jet (MS Access), MS SQL-Server). It contains an editor for Database Schema, Drag & Drop GUI editor for forms and a forms-server. 

It is quit old 20 year old programm written as my student work

# Documentation #

see the html documentation in directory docs/docu (German) or docs/docu_en (English)

# Programming #

Xdobry ist programmed in Tcl but it used many Tcl Extensions:

 * Tk
 * Tix
 * TclX
 * tDOM
 * Xotcl

# Installation #

You will need tcl and many extension to get it run.
There are windows binaries in releases.

For ubuntu

   sudo apt-get install tcl tk nsf

Start
 
   wish SchemaEditor.tcl
   wish FormEditor.tcl
   wish FormServer.tcl
