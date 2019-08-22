#! /bin/bash


#set -x
T_inicial=`date +%s`
IP_CORREIO="200.196.219.192"
DATA_HOJE=$(date "+%d/%m/%Y")
HORA_ATUAL=$(date +%T)
PATH_LOGS=/dados/scripts/logs/newspaperListaSpam.log
PATH_SPAM_EMAIL_NR_LOG=/dados/scripts/logs/listaSpamEmail_NR.txt
PATH_DELIVERY_EMAIL_NR_LOG=/dados/scripts/logs/listaDeliveryEmail_NR.txt
PATH_FILTER_SPAM_NR_LOG=/dados/scripts/logs/filterSpam_NR.log
PATH_CURRENT_NR=/var/log/qmail/current
HORA_ID_DELIVERY_NR_LOG=/dados/scripts/logs/correio_NR.txt
HORA_ID_SPAM_NR_LOG=/dados/scripts/logs/correioSpam_NR.txt

PATH_SPAM_EMAIL_RT_LOG=/dados/scripts/logs/listaSpamEmail_RT.txt
PATH_DELIVERY_EMAIL_RT_LOG=/dados/scripts/logs/listaDeliveryEmail_RT.txt
PATH_FILTER_SPAM_RT_LOG=/dados/scripts/logs/filterSpam_RT.log
PATH_CURRENT_RT=/var/log/qmail
PATH_NAME_CURRENT_RT=`ssh root@$IP_CORREIO ls -lhtr /var/log/qmail/@* | tail -n1 | awk '{print $8}' | cut -d'/' -f5`
THRESHOLD_INICIO_RT=`date -d "03:30:00" +%s` #THRESHOLD_INICIO_RT 03:30
HORA_ID_DELIVERY_RT_LOG=/dados/scripts/logs/correio_RT.txt
HORA_ID_SPAM_RT_LOG=/dados/scripts/logs/correioSpam_RT.txt

#LIMPEZA DE LOGS
>$HORA_ID_SPAM_NR_LOG
> $HORA_ID_DELIVERY_NR_LOG
> $PATH_DELIVERY_EMAIL_NR_LOG
> $PATH_LOGS
> $PATH_SPAM_EMAIL_NR_LOG
> $PATH_FILTER_SPAM_NR_LOG

> $HORA_ID_SPAM_RT_LOG
> $HORA_ID_DELIVERY_RT_LOG
> $PATH_DELIVERY_EMAIL_RT_LOG
> $PATH_FILTER_SPAM_RT_LOG
> $PATH_SPAM_EMAIL_RT_LOG

#COLETO ID E HORA SEM FILTRO COLOCO LOG /dados/scripts/logs/correio_NR.txt ""DELIVERY NR""
HORA_ID_DELIVERY_NR=`ssh root@$IP_CORREIO "grep '-'i 'accepted_message' $PATH_CURRENT_NR | tai64nlocal" | awk '{print$2,$4}' | tr -s '.' '_' | tr -s ' ' '_' | cut -d"_" -f1,3 | sed s/:$//g`
echo $HORA_ID_DELIVERY_NR >> $HORA_ID_DELIVERY_NR_LOG

#COLETO ID E HORA SEM FILTRO COLOCO LOG /dados/scripts/logs/correioSpam_NR.txt ""SPAM NR""
HORA_ID_SPAM_NR=`ssh root@$IP_CORREIO "grep '-i' 'To_best_protect_our_users_from_spam' $PATH_CURRENT_NR |  tai64nlocal" | awk '{print$2,$4}' | tr -s '.' '_' | tr -s ' ' '_' | cut -d"_" -f1,3 | sed s/:$//g`
echo $HORA_ID_SPAM_NR >> $HORA_ID_SPAM_NR_LOG

#FUNÇÃO COLETA ID E FAZ ASSOCIAÇÃO COM EMAIL EXIBE: HORA ID TIMESTAMP EMAIL E COLOCA LOG /dados/scripts/logs/listaDeliveryEmail_NR.txt  SOMENTE ID EMAIL
function id_TO_EmailDelivery_NR {
for i in `cat $HORA_ID_DELIVERY_NR_LOG`
do

HORA_DELIVERY_NR=`echo $i | cut -d':' -f1,2`
ID_DELIVERY_NR=`echo $i | cut -d':' -f3 | cut -d'_' -f2`
TIMESTAMP_DELIVERY_NR=`date -d "$HORA_DELIVERY_NR" +%s`
GREP_EMAIL_DELIVERY_NR=`ssh root@$IP_CORREIO cat $PATH_CURRENT_NR | grep '-i' "starting delivery $ID_DELIVERY_NR" | awk {'print $9'}`
        echo HORA:$HORA_DELIVERY_NR ID:$ID_DELIVERY_NR EMAIL DELIVERY NR: $GREP_EMAIL_DELIVERY_NR >> $PATH_DELIVERY_EMAIL_NR_LOG
        echo HORA:$HORA_DELIVERY_NR ID:$ID_DELIVERY_NR EMAIL DELIVERY NR: $GREP_EMAIL_DELIVERY_NR
done
}

function id_TO_EmailSpam_NR {
for i in `cat $HORA_ID_SPAM_NR_LOG`
do

HORA_SPAM_NR=`echo $i | cut -d':' -f1,2`
ID_SPAM_NR=`echo $i | cut -d':' -f3 | cut -d'_' -f2`
TIMESTAMP_SPAM_NR=`date -d "$HORA_SPAM_NR" +%s`
GREP_EMAIL_SPAM_NR=`ssh root@$IP_CORREIO cat $PATH_CURRENT_NR | grep '-i' "starting delivery $ID_SPAM_NR" | awk {'print $9'}`

        echo HORA:$HORA_SPAM_NR ID:$ID_SPAM_NR EMAIL SPAM NR: $GREP_EMAIL_SPAM_NR >> $PATH_SPAM_EMAIL_NR_LOG
        echo HORA:$HORA_SPAM_NR ID:$ID_SPAM_NR EMAIL SPAM NR: $GREP_EMAIL_SPAM_NR
done
}

echo #################################### 2 PARTE SCRIPT LOG ROTACIONADO ###############################################

#COLOCA NO LOG O NOME DO ARQUIVO CURRENT ROTACIONADO ## RT ##
echo ARQUIVO CURRENT ROTACIONADO: $PATH_NAME_CURRENT_RT >> $PATH_LOGS

#COLETO ID E HORA SEM FILTRO COLOCO LOG /dados/scripts/logs/correio_NR.txt ""DELIVERY NR""
HORA_ID_DELIVERY_RT=`ssh root@$IP_CORREIO "grep '-'i 'accepted_message' $PATH_CURRENT_RT/$PATH_NAME_CURRENT_RT | tai64nlocal" | awk '{print$2,$4}' | tr -s '.' '_' | tr -s ' ' '_' | cut -d"_" -f1,3 | sed s/:$//g`
echo $HORA_ID_DELIVERY_RT >> $HORA_ID_DELIVERY_RT_LOG

#COLETO ID E HORA SEM FILTRO COLOCO LOG /dados/scripts/logs/listaSpamEmail_RT.txt ""SPAM NR""
HORA_ID_SPAM_RT=`ssh root@$IP_CORREIO "grep '-i' 'To_best_protect_our_users_from_spam' $PATH_CURRENT_RT/$PATH_NAME_CURRENT_RT |  tai64nlocal" | awk '{print$2,$4}' | tr -s '.' '_' | tr -s ' ' '_' | cut -d"_" -f1,3 | sed s/:$//g`
echo $HORA_ID_SPAM_RT >> $HORA_ID_SPAM_RT_LOG

#FUNÇÃO COLETA ID E FAZ ASSOCIAÇÃO COM EMAIL EXIBE: HORA ID TIMESTAMP EMAIL E COLOCA LOG /dados/scripts/logs/listaDeliveryEmail_NR.txt  SOMENTE ID EMAIL
function id_TO_EmailDelivery_RT {
for i in `cat $HORA_ID_DELIVERY_RT_LOG`
do
HORA_DELIVERY_RT=`echo $i | cut -d':' -f1,2`
ID_DELIVERY_RT=`echo $i | cut -d':' -f3 | cut -d'_' -f2`
TIMESTAMP_DELIVERY_RT=`date -d "$HORA_DELIVERY_RT" +%s`
GREP_EMAIL_DELIVERY_RT=`ssh root@$IP_CORREIO cat $PATH_CURRENT_RT/$PATH_NAME_CURRENT_RT | grep '-i' "starting delivery $ID_DELIVERY_RT" | awk {'print $9'}`
if [ "$TIMESTAMP_DELIVERY_RT" -le "$THRESHOLD_INICIO_RT" ]; then
        echo HORA:$HORA_DELIVERY_RT ID:$ID_DELIVERY_RT EMAIL DELIVERY RT:$GREP_EMAIL_DELIVERY_RT
else

echo HORA:$HORA_DELIVERY_RT ID:$ID_DELIVERY_RT EMAIL DELIVERY RT:$GREP_EMAIL_DELIVERY_RT
        echo HORA:$HORA_DELIVERY_RT ID:$ID_DELIVERY_RT EMAIL DELIVERY RT:$GREP_EMAIL_DELIVERY_RT >> $PATH_DELIVERY_EMAIL_RT_LOG
fi
done
}

function id_TO_EmailSpam_RT {
for i in `cat $HORA_ID_SPAM_RT_LOG`
do

HORA_SPAM_RT=`echo $i | cut -d':' -f1,2`
ID_SPAM_RT=`echo $i | cut -d':' -f3 | cut -d'_' -f2`
TIMESTAMP_SPAM_RT=`date -d "$HORA_SPAM_RT" +%s`
GREP_EMAIL_SPAM_RT=`ssh root@$IP_CORREIO cat $PATH_CURRENT_RT/$PATH_NAME_CURRENT_RT | grep '-i' "starting delivery $ID_SPAM_RT" | awk {'print $9'}`

if [ "$TIMESTAMP_SPAM_RT" -le "$THRESHOLD_INICIO_RT" ]; then
        echo HORA:$HORA_SPAM_RT ID:$ID_SPAM_RT EMAIL SPAM NR: $GREP_EMAIL_SPAM_RT
else
        echo HORA:$HORA_SPAM_RT ID:$ID_SPAM_RT EMAIL SPAM NR: $GREP_EMAIL_SPAM_RT >> $PATH_SPAM_EMAIL_RT_LOG
        echo HORA:$HORA_SPAM_RT ID:$ID_SPAM_RT EMAIL SPAM NR: $GREP_EMAIL_SPAM_RT

fi
done
}

id_TO_EmailDelivery_RT
id_TO_EmailSpam_RT

#FILTRO SOMENTE OS EMAILS QUE FORAM ENTREGUES E REMOVO AS LINHAS EM BRANCO
RECEIVED_BLANK_LINES_RT=$(cat $PATH_DELIVERY_EMAIL_RT_LOG | awk '{print $4}' | cut -d':' -f2 | sed '/^$/d')

#VERIFICA SE O ARQUIVO DESTA VARIAVEL MAIOR ZERO "FILE_EXIST_RT"
FILE_EXIST_RT=$(du -sb $PATH_SPAM_EMAIL_RT_LOG | awk '{ print $1 }')

FILTER_EMAIL_SPAM_RT=`cat /dados/scripts/logs/listaSpamEmail_RT.txt | awk '{print $6}'`

#VERIFICA NA LISTA DOS EMAILS SPAM SE EXISTE ALGUM EMAIL QUE TENTOU ENTREGAR POR 2 VEZ  E NÃO CONSEGUIU,SE OCORREU ISSO O USUARIO NÃO RECEBEU NEWSPAPER, SE NAO ENCONTRAR NENHUM OU ENCONTRAR SÓ 1, FOI ENTREGUE COM SUCESSO.

if [[ "$FILE_EXIST_RT" -eq "0" ]]; then
        echo "TODOS USUARIOS LISTA CURRENT RECEBERAM NEWSPAPER_RT"
        echo "TODOS USUARIOS LISTA CURRENT RECEBERAM NEWSPAPER_RT" >> $PATH_LOGS
else
for i in `echo $FILTER_EMAIL_SPAM_RT`
do
NOT_RECEIVED_RT=`cat $PATH_SPAM_EMAIL_RT_LOG | grep "$i" | wc -l`
if [[ "$NOT_RECEIVED_RT" -ge "2" ]]; then
        #echo EMAIL:$i NÃO RECEBEU NEWSPAPER_RT
        echo EMAIL:$i NÃO RECEBEU NEWSPAPER_RT  >> $PATH_FILTER_SPAM_RT_LOG
elif [[ "$NOT_RECEIVED_RT" -le "1" ]]; then
        echo EMAIL:$i RECEBEU NEWSPAPER_RT
fi
done
fi

#INFORMAÇÃO DE QUANTOS EMAILS FORAM ENTREGUES
QTD_EMAIL_DELIVERY_RT=$(cat $PATH_DELIVERY_EMAIL_RT_LOG | awk '{print $4}' | cut -d':' -f2 | sed '/^$/d' | wc -l)
echo QUANTIDADE EMAILS DELIVERY_RT=$QTD_EMAIL_DELIVERY_RT
echo QUANTIDADE EMAILS DELIVERY_RT=$QTD_EMAIL_DELIVERY_RT >> $PATH_LOGS

#INFORMAÇÃO DE QUANTOS EMAILS NÃO FORAM ENTREGUES
QTD_EMAIL_SPAM_RT=$(cat $PATH_SPAM_EMAIL_RT_LOG | awk '{print $4}' | cut -d':' -f2 | sed '/^$/d' | wc -l)
QTD_EMAIL_SPAM_FINAL_RT=$(cat $PATH_FILTER_SPAM_RT_LOG | grep -i "EMAIL" | sort -u | wc -l)
echo QUANTIDADE EMAILS SPAM_RT=$QTD_EMAIL_SPAM_RT
echo QUANTIDADE EMAILS SPAM_RT=$QTD_EMAIL_SPAM_RT >> $PATH_LOGS
echo DOS $QTD_EMAIL_SPAM_RT EMAILS ENCONTRADOS NA LISTA DE SPAM_RT,$QTD_EMAIL_SPAM_FINAL_RT NÃO FORAM ENTREGUES
echo DOS $QTD_EMAIL_SPAM_RT EMAILS ENCONTRADOS NA LISTA DE SPAM_RT,$QTD_EMAIL_SPAM_FINAL_RT NÃO FORAM ENTREGUES  >> $PATH_LOGS


#COLETA SOMENTE OS EMAILS QUE NÃO FORAM ENVIADOS REMOVENDO AS LINHAS EM  BRANCO
NOT_RECEIVED_FILTER_RT=$(cat $PATH_FILTER_SPAM_RT_LOG | grep -i "NÃO RECEBEU NEWSPAPER_RT" | awk '{print $1}' | cut -d':' -f2)

echo
echo >> $PATH_LOGS
#ORGANIZA UM EMAIL AO LADO DO OUTRO E REMOVE EMAILS REPETIDOS
echo "$NOT_RECEIVED_FILTER_RT" | xargs -n1 | sort -u | xargs >> $PATH_LOGS
echo "$NOT_RECEIVED_FILTER_RT" | xargs -n1 | sort -u | xargs
echo
echo >> $PATH_LOGS
#------------------------------------------------------------------------------------------------------------------
# FAZ PARTE EMAILS NAO ROTACIONADOS "CURRENT"

id_TO_EmailDelivery_NR
id_TO_EmailSpam_NR

#FILTRO SOMENTE OS EMAILS QUE FORAM ENTREGUES E REMOVO AS LINHAS EM BRANCO
RECEIVED_BLANK_LINES_NR=$(cat $PATH_DELIVERY_EMAIL_NR_LOG | awk '{print $3}' | cut -d':' -f2 | sed '/^$/d')

#VERIFICA SE O ARQUIVO DESTA VARIAVEL MAIOR ZERO "FILE_EXIST_NR_"
FILE_EXIST_NR=$(du -sb $PATH_SPAM_EMAIL_NR_LOG | awk '{ print $1 }')

FILTER_EMAIL_SPAM_NR=`cat /dados/scripts/logs/listaSpamEmail_NR.txt | awk '{print $6}'`

#VERIFICA NA LISTA DOS EMAILS SPAM SE EXISTE ALGUM EMAIL QUE TENTOU ENTREGAR POR 2 VEZ  E NÃO CONSEGUIU,SE OCORREU ISSO O USUARIO NÃO RECEBEU NEWSPAPER, SE NAO ENCONTRAR NENHUM OU ENCONTRAR SÓ 1, FOI ENTREGUE COM SUCESSO.

if [[ "$FILE_EXIST_NR" -eq "0" ]]; then
        echo "TODOS USUARIOS LISTA CURRENT RECEBERAM NEWSPAPER_NR"
        echo "TODOS USUARIOS LISTA CURRENT RECEBERAM NEWSPAPER_NR" >> $PATH_LOGS
else
for i in `echo $FILTER_EMAIL_SPAM_NR`
do

NOT_RECEIVED_NR=`cat $PATH_SPAM_EMAIL_NR_LOG | grep "$i" | wc -l`
if [[ "$NOT_RECEIVED_NR" -ge "2" ]]; then
        #echo EMAIL:$i NÃO RECEBEU NEWSPAPER_NR
        echo EMAIL:$i NÃO RECEBEU NEWSPAPER_NR  >> $PATH_FILTER_SPAM_NR_LOG
elif [[ "$NOT_RECEIVED_NR" -le "1" ]]; then
        echo EMAIL:$i RECEBEU NEWSPAPER_NR
fi
done
fi

#INFORMAÇÃO DE QUANTOS EMAILS FORAM ENTREGUES
QTD_EMAIL_DELIVERY_NR=$(cat $PATH_DELIVERY_EMAIL_NR_LOG | awk '{print $3}' | cut -d':' -f2 | sed '/^$/d' | wc -l)
echo QUANTIDADE EMAILS DELIVERY_NR=$QTD_EMAIL_DELIVERY_NR
echo QUANTIDADE EMAILS DELIVERY_NR=$QTD_EMAIL_DELIVERY_NR >> $PATH_LOGS

#INFORMAÇÃO DE QUANTOS EMAILS NÃO FORAM ENTREGUES
QTD_EMAIL_SPAM_NR=$(cat $PATH_SPAM_EMAIL_NR_LOG | awk '{print $3}' | cut -d':' -f2 | sed '/^$/d' | wc -l)
QTD_EMAIL_SPAM_FINAL_NR=$(cat $PATH_FILTER_SPAM_NR_LOG | grep -i "EMAIL" | sort -u | wc -l)

echo QUANTIDADE EMAILS SPAM_NR=$QTD_EMAIL_SPAM_NR
echo QUANTIDADE EMAILS SPAM_NR=$QTD_EMAIL_SPAM_NR >> $PATH_LOGS
echo DOS $QTD_EMAIL_SPAM_NR EMAILS ENCONTRADOS NA LISTA DE SPAM NR,$QTD_EMAIL_SPAM_FINAL_NR NÃO FORAM ENTREGUES
echo DOS $QTD_EMAIL_SPAM_NR EMAILS ENCONTRADOS NA LISTA DE SPAM NR,$QTD_EMAIL_SPAM_FINAL_NR NÃO FORAM ENTREGUES  >> $PATH_LOGS

#COLETA SOMENTE OS EMAILS QUE NÃO FORAM ENVIADOS REMOVENDO AS LINHAS EM  BRANCO
NOT_RECEIVED_FILTER_NR=$(cat $PATH_FILTER_SPAM_NR_LOG | grep -i "NÃO RECEBEU NEWSPAPER_NR" | awk '{print $1}' | cut -d':' -f2)

echo
echo >> $PATH_LOGS
#ORGANIZA UM EMAIL AO LADO DO OUTRO E REMOVE EMAILS REPETIDOS
echo "$NOT_RECEIVED_FILTER_NR" | xargs -n1 | sort -u | xargs
echo "$NOT_RECEIVED_FILTER_NR" | xargs -n1 | sort -u | xargs >> $PATH_LOGS
echo
echo >> $PATH_LOGS
#-----------------------------------------------------------------------------------------------------------------------
T_final=`date +%s`
soma=`expr $T_final - $T_inicial`
resultado=`expr 10800 + $soma`
tempo=`date -d @$resultado +%H:%M:%S`
echo " Tempo gasto: $tempo "
echo "DATA:$DATA_HOJE $HORA_ATUAL -- Tempo gasto: $tempo " >> $PATH_LOGS
exit 0
