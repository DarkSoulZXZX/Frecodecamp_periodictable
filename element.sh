#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

DISPLAY_ELEMENT_INFO()
{
  ATOMIC_NUMBER=$1
  ELEMENTS=$($PSQL "SELECT ELEMENTS.NAME, ELEMENTS.SYMBOL, TYPES.TYPE, PROPERTIES.ATOMIC_MASS, PROPERTIES.MELTING_POINT_CELSIUS, PROPERTIES.BOILING_POINT_CELSIUS FROM PROPERTIES INNER JOIN ELEMENTS ON PROPERTIES.ATOMIC_NUMBER = ELEMENTS.ATOMIC_NUMBER INNER JOIN TYPES ON PROPERTIES.TYPE_ID = TYPES.TYPE_ID WHERE ELEMENTS.ATOMIC_NUMBER=$ATOMIC_NUMBER")
  echo $ELEMENTS | while read NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
  do
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
}

if [[ -z $1 ]]
  then
    echo 'Please provide an element as an argument.'
  else 
  ATOMIC_NUMBER=$($PSQL "SELECT ATOMIC_NUMBER FROM ELEMENTS WHERE ATOMIC_NUMBER=$1")
  if [[ -z $ATOMIC_NUMBER ]] 
    then
     ATOMIC_NUMBER=$($PSQL "SELECT ATOMIC_NUMBER FROM ELEMENTS WHERE SYMBOL='$1'")
    if [[ -z $ATOMIC_NUMBER ]]
      then
        ATOMIC_NUMBER=$($PSQL "SELECT ATOMIC_NUMBER FROM ELEMENTS WHERE NAME='$1'")
        if [[ -z $ATOMIC_NUMBER ]]
          then
            echo "I could not find that element in the database."
        else 
          DISPLAY_ELEMENT_INFO $ATOMIC_NUMBER
        fi
      else 
        DISPLAY_ELEMENT_INFO $ATOMIC_NUMBER
    fi
  else 
    DISPLAY_ELEMENT_INFO $ATOMIC_NUMBER
  fi
fi

