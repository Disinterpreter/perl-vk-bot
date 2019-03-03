#!/bin/sh


DIRS='
/opt/perl-bot
'

for line in $(pgrep -f /opt/perl-bot)
do
  kill -9 $line
#  rm $line
done


for run_dir in ${DIRS}
do
  pgrep -f "${run_dir}" > /dev/null || uwsgi -b 32768 --plugins psgi --socket 127.0.0.1:85 --psgi /opt/perl-bot/hook.pl --processes 2 --master --chdir /opt/perl-bot --daemonize /var/log/uwsgi/perl-bot.log --pidfile /var/run/uwsgi/perl-bot.pid
done







