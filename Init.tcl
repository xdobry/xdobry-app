#####################################################################
# Copyright (C) 2000 Artur Trzewik
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
######################################################################
# Header
# CVS - $Id: Init.tcl,v 1.6 2001/01/06 14:50:04 artur Exp $
#
# Information:
# Eine Zentrale Datei, die weitere Komponenten des TCL lädt
# Auch ein Punkt für nötige Systemanpassungen
# XOTcl
# TclX
# tDom
# initieren von postgres und mysql Schnittstellen

package require Tk
package require XOTcl

if {![xotcl::Object isobject Object]} {
   namespace import xotcl::*
}

namespace import msgcat::mc

puts "xotcl [set xotcl::version][set xotcl::patchlevel]"

package require Tix
package require tdom

set helpdir /usr/share/doc/xdobry-0.30/docu

tix addbitmapdir [file join $progdir bitmaps]

package require IDEErrorReporter
ErrorReporter set version 0.31
ErrorReporter set appName xdobry

source [file join $progdir ideBgError.tcl]
# Use Tclx if availabe than not use pure-tcl keyed list implementation

if {[catch {package require Tclx}]} {
    package require KeyedList
}

package require xdobry::Base
XDBase set xotclLocal 1

Object IDE
Object IDE::System
IDE::System proc isTkNeverThan84 {} {
    global tk_version
    expr {$tk_version>=8.4}
}
package provide IDECore 1.0
package require IDEBaseGUI
package require xdobry::Container
package require xdobry::WidgetLib
package require xdobry::Dialog
