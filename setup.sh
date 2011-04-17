#!/bin/sh

# Install tmux configuration & scripts

# First - just sanity check that we're in our setup directory
if [ ! -f .2993b6b548000a80989a20549e7558a5 ] ; then
  echo "Please run this script from the same directory the setup.sh is in"
  echo "If you are doing that, make sure the package is intact because a"
  echo "file called \".2993b6b548000a80989a20549e7558a5\" is missing"
  exit
fi

# Install scripts
read -p "By default scripts are stored in $HOME/bin - would you like them here? [y/n]: " CONT

if [ $CONT == 'y' -o $CONT == 'Y' ] ; then
  SCRIPT_DIR="$HOME/bin"
else
  read -p "OK, what directory would you like them in? (full path please) : " NEW_DIR
  echo "Using \"$NEW_DIR\" for scripts"
  SCRIPT_DIR=$NEW_DIR
fi

# Check to see if specified directory exists
if [ ! -d $SCRIPT_DIR ] ; then
  read -p "Directory \"$SCRIPT_DIR\" does not appear to exist, should I create it? [y/n]: " CREATE_DIR

# If we need to create the directory - we check with the user & then do it
  if [ $CREATE_DIR == 'y' -o $CREATE_DIR == 'Y' ] ; then
    echo "This will create the directory \"$SCRIPT_DIR\" relative to your CWD - currently \"$PWD\""
    read -p "Press ENTER to continue: " CONT
    mkdir -v $SCRIPT_DIR

# We can't really proceed w/out a destination directory
  else
    echo "Aborting, cannot copy scripts if destination directory does not exist"
    exit
  fi

else
# Start copying scripts
  for f in bin/*
  do
    cp -vi $f $SCRIPT_DIR/$f
  done
  echo "Scripts copied to \"$SCRIPT_DIR\""

# Discover what aliases file, if any, is in use

# First check .bashrc
  ALIASES=egrep -m 1 -o ' \S*\.\S*alias\S*' $HOME/.bashrc

# If that guy doesn't return anything, check bash_profile
  if [ -z $ALIASES ] ; then
    ALIASES=egrep -m 1 -o ' \S*\.\S*alias\S*' $HOME/.bash_profile
  fi

# If the variable is still empty we abort, otherwise append to aliases file
  if [ -z $ALIASES ] ; then
    echo "Sorry, couldn't determine where to put your alias, please follow the manual instructions for that part"
    exit
  else 
    if [ -f $ALIASES ] ; then
      echo "Appending aliases to \"$ALIASES\""
      cat aliases >> $ALIASES
    else 
      echo "File $ALIASES doesn't seem to exist, skipping alias, please follow the manual instruction in the README"
      exit
  fi
fi
