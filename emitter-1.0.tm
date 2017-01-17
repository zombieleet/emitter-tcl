#!/usr/bin/env tclsh
package provide emitter 1.0
# create Emiiter Class
oo::class create Emitter {
    # event names will be used as the index of Stack array
    #   while the procedure to trigger will be the value of the event index
    variable Stack
    
    # The total number of listeners allowed
    variable maxListeners 1000
    
    # newEvents will be assigned here if and only if the newListener event is attached
    variable newEvent

    # this constructor takes a single argument which is optional
    #  if the argument is specified , it is used as the default listener
    #  if it is not specified maxListeners is used as the default
    constructor { { mlistener 1000} } {
	
	set maxListeners $mlistener
	
    }

    # attach events to the Stack
    #  takes two argument ( compulsory )
    #  the event name and the procedure to trigger when ever the event is emitted
    method attach { eventName procedureName } {
	
	# prevent events to be added to the listener Stack
	#   if the total size of the Stack is already equal to the maximum amount of events to listen for
	if { [ array size Stack ] == $maxListeners } {
	    
	    error "only $maxListeners events are allowed in [self]"
	    
	}

	# Loop through the Stack if an event already exists
	#   don't attach it, throw an error
	foreach stackList [array names Stack] {
	    
	    if { $eventName == $stackList } {
		
		error "$eventName already exist in [self]"
		
	    }
	}

	# If the procedure specified does not exists
	#  throw an error
	if { ! [ catch { [info args $procedureName ] } ] } {
	    
	    error "$procedureName is not defined"
	    
	}
	
	# set the event name as index and the procedure name as value
	array set Stack [list $eventName $procedureName]

	# anytime a new event is attached
	#  if newListener is listened for,
	#  emit the newListener event
	#  if any event is attached
	#  that eventname with its procedure is passed to the procedure
	#  that will be triggered
	if { [lsearch [array names Stack] newListener] != -1 } {
	    
	    set newEvent [list $eventName $procedureName]
	    my emit newListener {*}$newEvent
	}
    }
    
    method emit { eventName args } {
	
	set arrayList [array names Stack]
	
	set searchIndex [lsearch $arrayList $eventName]

	# if serarchIndex is -1 throw error
	if { $searchIndex == -1 } {
	    
	    error "$eventName has not been attached as a listener to [self]"
	    
	}
	
	# get the value of searchIndex
	set listIndex [lindex $arrayList $searchIndex]

	# The procedure for newListener event must be NewListener
	if { $Stack($listIndex) == "NewListener" } {
	    
	    $Stack($listIndex) {*}$newEvent ;#{*}$args
	    
	    return
	}
	
	$Stack($listIndex)  $eventName "$Stack($listIndex)" {*}$args
    }
    
    method detach { eventName } {
	
	set arrayList [array names Stack]
	set searchIndex [lsearch $arrayList $eventName]
	
	if { $searchIndex == -1 } {
	    
	    error "$eventName has not been attached as a listener [self]"
	    
	}
	# remove the specified event
	unset Stack([lindex $arrayList $searchIndex])
    }
    
    method detachAll { } {

	# remove all events
	if { [array size Stack ] } {
	    
	    array unset Stack
	    return
	    
	}

	error "nothing to detach since the event Stack is empty"

    }
    
    method list { } {
	# list all events with its procedure name
	foreach events [array names Stack] {
	    
	    puts "$events $Stack($events)"
	    
	}
    }
    
}
