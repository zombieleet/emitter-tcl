# Emitter-Tcl
Emitter-Tcl is a  library for Tcl that helps you to be able to create custom event listeners and assign a function to be executed whenever the listener is been emitted


# Usage
clone this repo

`git clone https://github.com/zombieleet/emitter-tcl`

copy emitter-tcl to your project folder and follow the below steps

**Loading emitter-tcl**
```tcl
# specifiy a path to load the module from
# Adding the path to load emitter-tcl from as your current working directory 
#   i.e your project directory
  if {[lsearch [::tcl::tm::path list] [pwd]] < 0 } {
    ::tcl::tm::path add [pwd]
  }
  package require emitter

```

**attaching events**

Before attaching any event to listen for , you must first of all create an object since emitter-tcl is built with TCLOO

the attach method takes the event listen for and also a procedure name to execute when the event is emitted
if the procedure has not been created or the event you are attaching has already been attached an error is throwed

```tcl

# specifiy a path to load the module from
# Adding the path to load emitter-tcl from as your current working directory 
#   i.e your project directory
  if {[lsearch [::tcl::tm::path list] [pwd]] < 0 } {
    ::tcl::tm::path add [pwd]
  }
  package require emitter

# create fileObj object


  Emitter create fileObj

  proc CreateFile { args } {
    set ftocreate [lindex $args 2]
    set fval [open $ftocreate w]
    close $fval
    puts "$fval has been created"
  }

  # the attach method takes two argument which is the name of the event you want to listen for and the function to execute when the event is emitted

  fileObj attach createfile CreateFile ;#createfile is the event to listen for, CreateFile is the callback function to execute when the event is emitted
  fileObj attach showfile ReadFile ;# showfile is the event to listen for, ReadFile is the callback function to execute when the event is emitted

```

**emitting events**

the first argument to the `emit` method must be the the event you want to listen for and it must have already been added to the event stack with the `attach` method , the second argument must be the list  of all the argument which will be passed to the callback procedure (behind the hood) assigned to the event you want to listen for when you attached the event

Note:- You must not pass the arguments to the callback procedure directly when createing the event listener with the `attach` method

Note:- Under the hood, 2 other argument are passed to the callback procedure which is the name of the event listend for and the function that will be fired if the event is emitted


```tcl

  object attach talk SayScript ;# talk is the event to listen for, SayScript is the callback procedure to execute when the event talk is been emitted

  object emit talk tcl bash perl python; # talk is the event to listen for, "tcl bash perl python" is the argument passed to SayScript

```


```tcl

# specifiy a path to load the module from
# Adding the path to load emitter-tcl from as your current working directory 
#   i.e your project directory
  if {[lsearch [::tcl::tm::path list] [pwd]] < 0 } {
    ::tcl::tm::path add [pwd]
  }
  package require emitter

  proc File { } {
    if { ! [file exists log.txt]} {
      fileObj emit createfile log.txt
      return ;
    }
    event emit showfile log.txt
  }

# create fileObjs object

  Emitter create fileObj

  proc CreateFile { args } {
    set ftocreate [lindex $args 2]
    set fval [open $ftocreate w]
    puts $fval "tcl is great"
    close $fval
    # ---- changed -----
    fileObj emit showfile $ftocreate
  }

  proc ReadFile { args } {
    set ftoRead [lindex $args 2]
    set fval [open $ftoRead r]
    set ff [gets $fval rr]
    while {[eof $fval ] == 0 } {
        puts $rr
        set ff [gets $fval rr]
    }
  }
  # the attach method takes two argument which is the name of the event you want to listen for and the function to execute when the event is emitted

  fileObj attach createfile CreateFile ;#createfile is the event to listen for, CreateFile is the callback function to execute when the event is emitted
  fileObj attach showfile ReadFile ;# showfile is the event to listen for, ReadFile is the callback function to execute when the event is emitted

```

**detaching an event**

to detach an event means to remove a particular event from the stack. the `detach` method only requires a single argument which is the event name

**deatchAll event**

to detach all event means to remove every single event listener from the stack. the `detachAll` method is use for this



**list event**

the `list` method list all attached events and their correspeonding executor ( procedure to execute when the event is emitted)

**newListener**

the `newListener` event , is an event that is already emitted in the module
if you attach this event , any subsequent event you attach will be emitted, the name of the event and the executor will be passed to the executor of the `newListener` event
the executor of the `newListener` event must be `NewListener`

```tcl

  proc NewListener { args } {
    set eventName [lindex $args 0]
    if { [regexp -all -- {-} $eventName] } {
      puts "$eventName contains invalid characters"
      puts "only alpha numeric characters should be use use for event names"
      fileObj detach $eventName 
    } 
  }

  fileObj attach newListener NewListener


```

# Working with inheritance

**Inheriting from Emitter class**

```tcl

oo::class create MyCustomEvent {
    superclass Emitter
    variable gamer
    constructor(args) {
      next {*}$args
    }
    method myMeth { } {
      my emit evt "emited"
    }

  MyCustomEvent create mycEvent

  proc Say { $args } {
    set evtName [lindex $args 0]
    set pName [lidnex $args 1]
    set text [lindex $args 2]
    puts " $evtName has been $text in $pName proc"
  }
  mycEvent attach evt Say    

```

#License

GNU Version 2
