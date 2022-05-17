#!/bin/bash

#description : exec script to create random password that include characters, numbers, special signs

str='abcdefghijklmnopqrstuvwxyz,./<>?[]{}1234567890-=\!@#$%^&*()_+|ABCDEFGHIJILMNOPQRSTUVWXYZ'


len=$(expr length $str)

num=15
for i in  `seq $num`;do
   ran=$(date +%s%N)

   n=$(($ran % $len))
   rstr=${rstr}${str:$n:1}
done

echo "${rstr}"

exit 0
