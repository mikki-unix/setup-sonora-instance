#!/bin/bash

if [ "$EUID" -ne 0 ]; then 
	echo -e 'A execução deste script depende dos privilégios do superusuário.\nUse sudo ao executar o script ou troque para a sessão do superusuário utlizando su root.' 
	exit
fi

parar_apos_erro() {
	sleep 0.5
	echo 'Ocorreu um erro.'
	sleep 0.5
	echo 'O script será encerrado. Trate o erro e tente executar o script novamente.'
	echo 'Você pode passar o parâmetro --skip na chamada do script para resumir a execução.'
	exit
}
trap 'parar_apos_erro' ERR

executar_setup() {
	echo -e '\nAtualizando os pacotes do sistema...'
	apt update
	echo 'Feito.'

	echo 'Instalando Docker...'
	apt install docker -y
	echo 'Feito.'

	echo 'Clonando repositório safrinis, para usar no container node...'
	git clone https://github.com/shell-y/safrinis ../safrinis
	echo 'Feito.'

	echo 'Construindo imagem Docker node-sonora...'
	docker build -t node-sonora -f ./dockerfiles/Dockerfile-node ../
	echo 'Feito.'

	echo 'Fazendo pull da imagem Docker mysqsl:8...'
	docker pull mysql:8
	echo 'Feito.'

	echo 'Instalando Docker-Compose...'
	apt install docker-compose -y
	echo 'Feito.'

	echo 'Inicializando containers usando o docker-compose...'
	docker-compose up -d
	echo 'Feito.'
	
	sleep 1
	echo -e '\nFim do script.'
	sleep 0.5
	echo -e '\nSua instância Sonora está totalmente prepara!'
	sleep 1
}

if [ $1 == '--skip' ]; then
	executar_setup
	exit
fi

echo 'CELEBRE COM' | awk '{ printf "%*s\n", (80 + length($0)) / 2, $0 }'
echo "------------   --------   ----    ----   --------   -----------     ------    ";
echo "************  **********  *****   ****  **********  ***********    ********   ";
echo "----         ----    ---- ------  ---- ----    ---- ----    ---   ----------  ";
echo "************ ***      *** ************ ***      *** *********    ****    **** ";
echo "------------ ---      --- ------------ ---      --- ---------    ------------ ";
echo "       ***** ****    **** ****  ****** ****    **** ****  ****   ************ ";
echo "------------  ----------  ----   -----  ----------  ----   ----  ----    ---- ";
echo "************   ********   ****    ****   ********   ****    **** ****    **** ";

sleep 1
echo "\n------------------------------------------------------------------------------";
sleep 0.5
echo -e '\nBoas vindas ao script de inicialização do seu ambiente em nuvem Sonora!'
sleep 2
echo -e '\nO processo é totalmente automático.\nPor tanto, você pode relaxar enquanto tudo é preparado.'
sleep 2
echo -e '\nA execução começará em instantes, e pode ser impedida à qualquer momento usando o atalho Ctrl + C\nSe desejar, das próximas vezes que executar o script você pode passar o parâmetro --skip para pular a introdução e resumir a preparação.'
sleep 1
echo "\n------------------------------------------------------------------------------";

executar_setup
