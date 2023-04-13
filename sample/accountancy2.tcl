# This is an sample Macro File for
# accontancy Database see manual (section FormServer)
# please use this file for your own macros as scratch
# The file is coded as tcl with Xotcl Extension
# pleaes see manual to get more information about this
# programm-lanugage 
# This file must be a correct tcl (xotcl) programm file!!
# Tcl is not so difficult as you think 

# Macros for costumer form
# Make your own class derived from FormEngine (coded in formengine.tcl)
# use Xotcl subclasses to beware naming problems
Class FormEngine::customer -superclass FormEngine

# You write your macro by overwriting some empty FormEngien procedures
# FormEngine instproc update_check klvalues_ref {
#     return 1
# }
# FormEngine instproc delete_check {} {
#     return 1
# }
# FormEngine instproc insert_check klvalues_ref {
#     return 1
# }
# FormEngine instproc after_delete {} {
# }
# FormEngine instproc reload_form {} {
# }
# FormEngine instproc position_check {pos} {
#     return 1
# }
# FormEngine instproc filling_form klvalues_ref {
# }

FormEngine::customer instproc delete_check {} {
    if {[tk_messageBox -message "Do you really want to delete this customer from your database"  -icon question -type okcancel]=="ok"} {
	# With this procedure you can read the primary key
	# Value of deleted object
	set pkey [[self] getKeyValue]
	# get sql connect variable
	[self] instvar sqlconnect
	# seuarch if this costumer has order he didn't paid
	set sqlstatment "SELECT orderId FROM cust_order WHERE custId=$pkey and paid=0"
	set query [$sqlconnect query $sqlstatment]
	if {[$query rows]>0} {
	    tk_messageBox -message "This costume can't not be deleted. He didn\'t paid some orders"  -icon warning -type ok
	    $query destroy
	    return 0
	}
	# Set all coresponding  custId in cust_order to NULL
	set sqlstatment "UPDATE cust_order SET custID=NULL WHERE custId=$pkey"
	$sqlconnect execute $sqlstatment
	[self] instvar sqlconnect
	
	return 1
    } 
    return 0
}

# Sample of computing derivered attributes
Class FormEngine::item -superclass FormEngine

FormEngine::item instproc filling_form klvalues_ref {
    # get sqlconnect instance varible
    [self] instvar sqlconnect
    # get the reference
    upvar $klvalues_ref values
    # values are tclx keyd list 
    # {{key1 value1} {key2 value2} {key3 value3}}
    # keys are names of attributes
    # the following tclx operation
    # keylget keylset keylkeys

    # extract all keys
    set vkeys [keylkeys values] 
    if {[lcontain $vkeys count]} {
	# get price information throw sql query
	set sqlstatment "SELECT price from product WHERE productId=[keylget values productId]"
	set query [$sqlconnect query $sqlstatment]
	set price [$query fetch]
	$query destroy
	set sum [expr $price * [keylget values count]]
	# new Attribute are added to vale list
	# it will by despled from a Entry Widget (data==sum)
	keylset values sum $sum
    }
}

Class FormEngine::cust_order -superclass FormEngine
FormEngine::cust_order instproc filling_form klvalues_ref {
    [self] instvar sqlconnect
    upvar $klvalues_ref values
    # get total of all item prices * count
    set sqlstatment "select sum(product.price*item.count) from product,item where item.productId=product.productId and item.orderId=[keylget values orderId]"
    set query [$sqlconnect query $sqlstatment]
    set total [$query fetch]
    $query destroy
    # new Attribute are added to vale list
    keylset values total $total
}
# sample of checking the constrains
FormEngine::cust_order instproc update_check klvalues_ref {
    upvar $klvalues_ref values
    set vkeys [keylkeys values] 
    if {[lcontain $vkeys date]} {
	if {![regexp {^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$} [keylget values date]]} {
	    tk_messageBox -message "The Date do not conform to format like 2000-02-20. Operation reejected"  -icon question -type okcancel	
	    return 0
	}
    }    
    return 1
}
FormEngine::cust_order instproc insert_check klvalues_ref {
    upvar $klvalues_ref values
    set vkeys [keylkeys values] 
    if {[lcontain $vkeys date]} {
	if {![regexp {^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$} [keylget values date]]} {
	    tk_messageBox -message "The Date do not conform to format like 2000-02-20. Operation reejected"  -icon question -type okcancel	
	    return 0
	}
    }    
    return 1
}

#
# Please Mail me if you succesful have written your own macros
# or if you have big trouble to do it
#
