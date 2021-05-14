/* REXX */
/*
   Sysgen Automation REXX script
   By: Philip Young (Soldier of FORTRAN)

   WARNING: This will only work when called from hercules

   To use:
   1) Start hercules with `hercules -f conf.file > hercules.log`
   2) Then call from hercules: exec automate.rexx file1.txt hercules.log

   License: GPL v2
*/
parse arg commands logfile debug

IF LENGTH(commands)=0 | LENGTH(logfile)=0 THEN DO
  SAY 'Hercules REXX Automation Script'
  SAY 'Missing challenge response file or hercules log file'
  SAY 'Usage: ./automate.rexx challenge_response_file.txt hercules_log.log [-debug]'
  EXIT 1;   /* exit script */
END;

/* creating a little lock file */
address 'hercules' 'sh touch failure'


say "Commands file: "||STREAM(commands,'C','QUERY EXISTS')
say "Log file: "||STREAM(logfile,'C','QUERY EXISTS')

IF LENGTH(debug)\=0 THEN DO
  debug = 1
END
ELSE DO
  debug = 0
END

CALL pd 'Debug enabled'

/* read all the lines first */
do while lines(logfile) \= 0
      readline = linein(logfile)
end


do while lines(commands) \= 0
  /* Loop through the commands file */
  t = linein(commands)
  parse var t expect ';' response

  if left(t,1) = '#' then do /* supports comments */
    say t
    iterate
  end

  if pos(';', t) = 0 then do
  /* Sometimes we need to run two commands, if we do we just place
  the seccond command after the first on a new line. Since it has
  no ; it will be executed */
    call pd 'Command on its own: '||t
    call sleep 1
    Address "HERCULES" t
    iterate
  end

  /* Does our expected line start with a reply number?
     if so, remove it because we can't know what the actual number
     will be */
  if left(expect,2) = "/*" then do
    parse var expect . expect
  end

  call pd 'Waiting for  : ' ||left(expect,length(expect) - 5)||"..."
  call pd 'Reply will be: ' ||response
  do forever
    /* Read the hercules log file */
    if lines(logfile) \= 0 then do
      /* If there's new lines, read them */
      readline = linein(logfile)


      if wordpos(expect, readline) \= 0 then do
        /*
           If we have a challenge, issue it then leave this while loop
           to get the next challenge response. If there are none we're
           done
        */

        /* remove the date/time column */
        parse var readline . readline

        if left(readline,2) = "/*" then do
          /* We don't know the reply number, get it and use it here */
          parse var readline reply .
          say "Reply Number: " reply
          reply = right(reply,length(reply)-2)
          say "Reply Number: " reply
          if left(response,2) = "/r" then do
              parse var response s split
              parse var split . ',' reply_string
              response = s||" "reply||","||reply_string
          end
        end

        call pd 'Found challenge, replying with: ' ||response
        call sleep 1 /* Without this it was too fast */

        if upper(response) = "QUIT" THEN do
          address 'hercules' 'sh rm failure'
        end

        Address "HERCULES" response
        leave
      end
    end
  end
end


/* removing the lock file */
address 'hercules' 'sh rm failure'
EXIT 0

pd: /* Prints if debug is enabled */
  parse arg s
  if debug then say s
 return

sleep: /* While regina has a sleep function it doesnt work in herc */
Parse Arg secs .
If Datatype(secs) <> 'NUM' Then secs = 60
rc = Time(R)
Do Forever
  n = Time(E)
  If n >= secs Then Leave
End
return

