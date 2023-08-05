#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --csv -t -c "

echo -e "\n~~~ Salon ~~~\n"

DISPLAY_SERVICES() {
  SERVICES=$($PSQL "select * from services")
  
  echo "$SERVICES" | while IFS="," read ID NAME
  do
    echo -e "$ID) $NAME"
  done
}

MAIN() {
  echo -e "\nChoose a service:\n"
  #display services
  DISPLAY_SERVICES
  read SERVICE_ID_SELECTED
  SERVICE_ID_SELECTED=$($PSQL "select service_id from services where service_id=$SERVICE_ID_SELECTED")
  while [[ -z $SERVICE_ID_SELECTED ]]
  do
    DISPLAY_SERVICES
    read SERVICE_ID_SELECTED
    SERVICE_ID_SELECTED=$($PSQL "select service_id from services where service_id=$SERVICE_ID_SELECTED")
  done

  echo -e "\nPhone Number:\n"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nName:\n"
    read CUSTOMER_NAME
    $PSQL "insert into customers(name, phone) values('$CUSTOMER_NAME', '$CUSTOMER_PHONE')"
  fi
  CUSTOMER_ID=$($PSQL "select customer_id from customers where name='$CUSTOMER_NAME'")
  SERVICE_NAME=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")
  
  echo -e "\nTime of Appointment:\n"
  read SERVICE_TIME
  $PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')"

  echo -e "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN

