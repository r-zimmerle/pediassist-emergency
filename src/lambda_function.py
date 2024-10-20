import json

def calcular_doses(peso_kg):
    doses = {}
    
    # Informações sobre a diluição de cada medicamento
    diluicoes = {
        'Medicamento A - Dose 1 (ml)': 'Diluído conforme protocolo X',
        'Medicamento A - Dose 2 (ml)': 'Diluído conforme protocolo X',
        'Medicamento A - Dose 3 (ml)': 'Diluído conforme protocolo X',
        'Medicamento B - Concentração Alta (ml)': 'Diluído conforme protocolo Y',
        'Medicamento B - Concentração Baixa (ml)': 'Sem diluição',
        'Medicamento C (ml)': 'Diluído conforme protocolo Z',
        'Medicamento D (ml)': 'Diluído conforme protocolo W',
        'Medicamento E (ml)': 'Sem diluição',
    }

    # Cálculo das doses
    doses['Medicamento A - Dose 1 (ml)'] = (peso_kg * 2) / 5
    doses['Medicamento A - Dose 2 (ml)'] = (peso_kg * 3) / 5
    doses['Medicamento A - Dose 3 (ml)'] = (peso_kg * 4) / 5
    doses['Medicamento B - Concentração Alta (ml)'] = peso_kg * 0.1
    doses['Medicamento B - Concentração Baixa (ml)'] = peso_kg * 0.1
    doses['Medicamento C (ml)'] = peso_kg * 0.2
    doses['Medicamento D (ml)'] = peso_kg * 0.3
    doses['Medicamento E (ml)'] = peso_kg * 0.1
    
    return doses, diluicoes

def lambda_handler(event, context):
    # Extrai o peso do evento
    try:
        body = json.loads(event['body'])
        peso = float(body['peso'])
    except (KeyError, TypeError, ValueError):
        return {
            'statusCode': 400,
            'body': json.dumps({'error': 'Parâmetro "peso" é obrigatório e deve ser um número válido.'})
        }
    
    # Calcula as doses
    doses, diluicoes = calcular_doses(peso)
    
    # Prepara a resposta
    resposta = {
        'doses': doses,
        'diluicoes': diluicoes
    }
    
    return {
        'statusCode': 200,
        'body': json.dumps(resposta)
    }
