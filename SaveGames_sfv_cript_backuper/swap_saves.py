# Exemplo de "switch case em Python"

import io
import os # Acesso so SO
import re # Regex
import shutil # Ferramentas para gerenciamento de arquivos

# Função responsável por atualizar o arquivo de configuração
def fidSwap(configsUpdated):

	try: 
		with open('config.txt', 'w') as configFile:
			# Obtém o caminho do diretório:
			dirPath = os.path.dirname(os.path.abspath( __file__ ))
			
			# Faz o backup dos arquivos correntes:
			shutil.copy("GameProgressSave.sav", "Backup_"+currentFid)
			shutil.copy("GameSystemSave.sav", "Backup_"+currentFid)
			
			# Restaura os saves do FID desejado:
			shutil.copy(dirPath+"\\Backup_"+configsUpdated['current_fid']+"\\"+"GameProgressSave.sav", '.')
			shutil.copy(dirPath+"\\Backup_"+configsUpdated['current_fid']+"\\"+"GameSystemSave.sav", '.')
			
			# Atualiza o arquivo de configuração
			configFile.write('current_fid='+configsUpdated['current_fid']+"\n")
			configFile.write('number_of_fid='+configsUpdated['number_of_fid'])

			print("FID trocada com sucessso =)")
	
	except Exception as e:
		print(e)

# Lendo o arquivo de configuração e criando um dicionário de configurações
try:
	with open('config.txt', 'r') as configFile:
		configs={}
		for line in configFile:
			if re.match("^[a-zA-Z]", line):
				config = line.split('=')
				configs[config[0]] = config[1]

except Exception as e:
	print(e)

# Lendo o arquivo com FIDs
try:
	with open('fids.txt', 'r') as fidFile:
		fids=[]
		for line in fidFile:
			line = line.replace(u'\n', u'')
			fids.append(line)		

except Exception as e:
	print(e)

try:
	# Verifica qual é o FID atual limpa a string para raw:
	currentFid = configs['current_fid'].replace(u'\n', u'')
	
	print("FID atual é: " + currentFid)
	print("Trocar para:\n")

	# Exibe as FIDs que podem ser escolhidas:
	for fid in fids:
		# Pega um FID raweia ela e imprime se ela for diferente da atual:
		rawFid = fid[4:].replace(u'\n', u'')
		if rawFid != currentFid:
			print(fid)

	fid = int(input("Escolha um: "))
	
	# Faz os procedimentos para a troca da FID atual para a nova:
	if fid != int(configs['number_of_fid']):
		
		if fid == 1:
			print("Trocando para Senshi-Hiro")
			configs['current_fid']='Senshi-Hiro'
			configs['number_of_fid']='1'
			fidSwap(configs)

		elif fid == 2:
			print("Trocando para SaltyLaura")
			configs['current_fid']='SaltyLaura'
			configs['number_of_fid']='2'
			fidSwap(configs)

		elif fid == 3:
			print("Trocando para Kin_Hiro")
			configs['current_fid']='Kin_Hiro'
			configs['number_of_fid']='3'
			fidSwap(configs)

		else:
			print("Esse FID não existe...")
	else:
		print("Ops! Você escolheu a FID atual.")

except Exception as e:
	print(e)
