# **PediAssist Emergencial: Assistente de Dosagem Pediátrica para Emergências Utilizando AWS**

Este projeto desenvolve uma aplicação serverless na **AWS** destinada a auxiliar médicos de emergência pediátrica no cálculo rápido e preciso das dosagens de medicamentos, seguindo protocolos médicos e diretrizes farmacológicas que consideram o peso do paciente como fator crucial. A necessidade desta ferramenta surgiu após uma conversa com uma colega médica de emergência pediátrica, que destacou o desafio de calcular dosagens em situações críticas, onde erros podem ser fatais. Em colaboração, desenvolvemos as equações necessárias para os cálculos, resultando em uma solução que alivia a carga de trabalho dos profissionais de saúde em momentos decisivos.

Em situações de emergência, onde cada segundo conta, esta ferramenta proporciona uma solução eficiente para calcular e ajustar as dosagens de medicamentos de forma imediata, contribuindo para a tomada de decisões clínicas seguras e eficazes.

## **Disclaimer**

**Aviso Legal:** Este aplicativo é fornecido apenas para fins informativos e educativos. Ele não substitui o julgamento clínico de profissionais de saúde qualificados. O desenvolvedor não se responsabiliza por quaisquer erros, omissões ou consequências decorrentes do uso desta ferramenta. Sempre consulte diretrizes clínicas e profissionais de saúde antes de tomar decisões relacionadas ao tratamento de pacientes.

## Tecnologias Utilizadas

- **AWS Lambda**: Hospeda a lógica de cálculo de dosagens, garantindo escalabilidade e alta disponibilidade.
- **AWS API Gateway**: Exposição da função Lambda através de endpoints HTTP seguros e gerenciáveis.
- **Amazon S3**: Armazenamento da interface web estática.
- **Terraform**: Gerenciamento da infraestrutura como código (IaC).
- **Python 3.8**: Linguagem utilizada para desenvolver a lógica de cálculo na função Lambda.
- **Progressive Web App (PWA)**: Interface web otimizada para dispositivos móveis.
