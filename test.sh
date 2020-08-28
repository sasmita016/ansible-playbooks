#! /bin/bash

##### To Check for Server uptime
srvup_check ()
{
UP=$(uptime |awk '{print $3}')
 if [ $UP -gt 60 ]
 then
  echo -e '\t' "Server uptime is more than 60 days,Server needs to be restarted"
 else
  echo -e '\t' "Server uptime is less than 60 days,Health check is fine"
fi
}

##### To Check for Packages installed
prg_check ()
{
if [ -f /etc/redhat-release ]
then
 PG_DT=$(rpm -qa --last |head -1|awk '{print $3$4$5}')
 pkg_check
elif [ -f /etc/os-release ]
then
 PG_DT=$(grep " install " /var/log/dpkg.log|head -1|awk '{print $1}')
 pkg_check
fi
}
pkg_check ()
{
 PST=$(date -d "$PG_DT" +%s)
 NW=$(date +%s)
 DF=$(($NW-$PST))
 DY=$(($DF/(3600*24)))
   if [ $DY -lt 30 ]
   then
    echo -e '\t' "Packages has been installed less than 30 Days,Server needs to be restarted"
   else
    echo -e '\t' "Packages has not been installed i last 30 Days,Health check is fine"
   fi
}

##### Execution
echo "Performing System health check"
echo "===============================>"
echo ""
srvup_check
prg_check
echo ""
