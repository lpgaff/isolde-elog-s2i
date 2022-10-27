#!/bin/bash

# Run elog, for testing
#elogd -p 9090 -c /etc/elogd.cfg -D

# Run elog, for real (old style)
elogd -p 8080 -c /elog-nfs/elogd.cfg

# Run elog, from EOS
#elogd -p 8080 -c /eos/home-i/isoelog/elog/elogd.cfg
