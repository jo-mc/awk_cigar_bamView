#!/bin/sh
column=${1:-3}
awk '{print $'$column'}'
