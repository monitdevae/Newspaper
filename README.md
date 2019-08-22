# Newspaper
Repositório sobre script desenvolvido pela monitoração.
Elaboramos um script para identificar os clientes que por algum motivo não receberam o Newspaper, a principio identificamos que a maior parte dos clientes tem e-mail do "Gmail", mas a lógica aplicada identifica qualquer provedor de e-mail. O script coleta as informações no servidor 200.196.219.192 "correio.ae.com.br".



O script esta rodando no servidor : 10.101.0.209 no diretório /dados/scripts/

 

Nome do script : newspaperListaSpam.sh

 

Inicialmente colocamos para monitorar no horário das : De seg. às sex  05:20am -  “Podendo ser ajustado de acordo com as necessidades”.

Para que o alarme no zabbix ocorra foi incluído o template abaixo :

Foram incluídas as configurações abaixo no servidor 10.101.0.209 /usr/local/etc/zabbix_agentd.conf : 
 
Foram incluídas as seguintes informações na CRON

#Script verifica os emails que não receberam Newspaper
20 5 * * * /dados/scripts/newspaperListaSpam.sh >/dev/null 2>&1
 
Como funciona script: 

O script coleta ID e HORA dos usuários que receberam Newspaper "RT - Sigla para Arquivo Rotacionado", e dos usuários que provavelmente não receberam. Para os usuários que receberam ele efetua um grep -i "accepted_message" e para os que provavelmente não receberam grep -i "To_best_protect_our_users_from_spam" , direciona essas informações para um log. Após isso faz um FOR e para cada ID encontrado ele procura o EMAIL pertencente à esse ID, e através de TIMESTAMP coloca no log somente os usuários que receberam o conteúdo após 03:30am. Apartir deste ponto o script trabalha somente com a lista dos usuários que provavelmente não receberam Newspaper, faz uma verificação e identifica quando o servidor tentou entregar por 2 vezes o conteúdo e não conseguiu considerando assim que este usuário não recebeu o Newspaper, quando a quantidade de vez que tentou entregar for menor ou igual a 1 significa que nas novas tentativas de entrega o cliente recebeu o conteúdo. Todas essas informações são colocadas em logs.

O mesmo processo é feito para o log que ainda não foi rotacionado que esta no diretório: /var/log/qmail/current

Siglas utilizadas dentro script: 

RT - Log rotacionado

NR - Log não rotacionado

As informação de log coletada  pelo script fica dentro do diretório : 

Tentei fazer todo tramite através de variáveis, porem infelizmente tive muitos problemas na hora de aplicar os filtros. Seguem os logs:

/dados/scripts/logs/newspaperListaSpam.log -- Log Principal contendo as informações de quem realmente não recebeu o Newspaper  

/dados/scripts/logs/correio_NR.txt

/dados/scripts/logs/correioSpam_NR.txt

/dados/scripts/logs/listaSpamEmail_NR.txt

/dados/scripts/logs/listaDeliveryEmail_NR.txt

/dados/scripts/logs/filterSpam_NR.log



/dados/scripts/logs/listaSpamEmail_RT.txt

/dados/scripts/logs/listaDeliveryEmail_RT.txt

/dados/scripts/logs/filterSpam_RT.log

/dados/scripts/logs/correio_RT.txt

/dados/scripts/logs/correioSpam_RT.txt

Como é exibido o alarme no zabbix :

Ao passar o mouse sobre o alarme será apresentado um link para que você possa verificar o que foi alterado:

Clicando em cima do link as informações são exibidas desta forma:

Foram criadas as condições para que ocorra o alarme e realizada as devidas dependências . 

Foi inclusa na aba dependência desta trigger o template de "Feriado Nacional", portanto quando for dia de feriado independente da configuração do alarme ele não aparecerá no zabbix.


Assim são exibidas as informações no log principal:

 Segue as informações para tratamento :

 Foi enviado um e-mail pelo Marcelo (Núcleos) explicando sobre como iremos atuar, mas na realidade será bem simples. Ao identificar o alarme o operador deverá coletar a lista de e-mail exibida no zabbix e encaminhas para o HelpDesk.

Pessoas que deverão receber o e-mail:  
Para: atende.ae@estadao.com   
Cc: livia.nogueira@estadao.com producao.ae@estadao.com mike.rosa@estadao.com   
