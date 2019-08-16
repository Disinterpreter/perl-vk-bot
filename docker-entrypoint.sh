#!/bin/bash
uwsgi -b 32768 --plugins psgi --socket 0.0.0.0:85 --psgi /kostyan/hook.pl --processes 2 --master --chdir /kostyan
