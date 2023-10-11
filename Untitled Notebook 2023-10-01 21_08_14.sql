-- Databricks notebook source
-- MAGIC %md
-- MAGIC https://kaggle.com/datasets/kuchhbhi/latest-laptop-price-list/
-- MAGIC

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Vários fatores diferentes podem afetar os preços dos laptops. Esses fatores incluem a marca do computador e o número de opções e complementos incluídos no pacote do computador. Além disso, a quantidade de memória e a velocidade do processador também podem afetar o preço. Embora menos comum, alguns consumidores gastam dinheiro adicional para comprar um computador com base na “aparência” geral e no design do sistema.
-- MAGIC
-- MAGIC Em muitos casos, os computadores de marca são mais caros do que as versões genéricas. Esse aumento de preço geralmente tem mais a ver com o reconhecimento do nome do que com qualquer superioridade real do produto. Uma grande diferença entre sistemas de marca e genéricos é que, na maioria dos casos, os computadores de marca oferecem melhores garantias do que as versões genéricas. Ter a opção de devolver um computador com defeito costuma ser um incentivo suficiente para incentivar muitos consumidores a gastar mais dinheiro.
-- MAGIC
-- MAGIC A funcionalidade é um fator importante na determinação dos preços dos laptops. Um computador com mais memória geralmente funciona melhor por mais tempo do que um computador com menos memória. Além disso, o espaço no disco rígido também é crucial e o tamanho do disco rígido geralmente afeta o preço. Muitos consumidores também podem procurar drivers de vídeo digital e outros tipos de dispositivos de gravação que podem afetar os preços dos laptops.
-- MAGIC

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Como obtivemos esses dados (essa tabela foi obtida por meio da plataforma Kaggle: https://www.kaggle.com/datasets/kuchhbhi/latest-laptop-price-list/):
-- MAGIC
-- MAGIC Removi esses dados de flipkart.com. Usou-se uma ferramenta automatizada de extensão da web do Chrome chamada Instant Data Scrapper
-- MAGIC recomendo fortemente que você use esta bela ferramenta para obter os dados de qualquer lugar na web. é muito fácil de usar, nenhum conhecimento de codificação é necessário.
-- MAGIC

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ANÁLISE DESCRITIVA (SQL)
-- MAGIC

-- COMMAND ----------

-- MAGIC %md
-- MAGIC APRESENTANDO O GRÁFICO

-- COMMAND ----------

-- MAGIC %md
-- MAGIC como a tabela está em cotação diferente, faz-se necessário realizar a conversão, neste dia, a rupia indiana estava em R$0,061
-- MAGIC
-- MAGIC é preciso também transforma a tabela "desconto" em percentual
-- MAGIC

-- COMMAND ----------

alter view vw_notebooks_vendidos 
as
select *, 
(latest_price * 0.061) preco_atual_real,
(old_price * 0.061) preco_anterior_real,
(discount/100) as desconto
from notebooks_vendidos

-- COMMAND ----------

select * from vw_notebooks_vendidos 

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Média de Preços por marca
-- MAGIC
-- MAGIC Foi realizado uma análise em ordem decrescente
-- MAGIC obs: sempre que tenho um grupo calculado e um não calculado, é preciso isolar o calculado com "group by" e o nome da coluna
-- MAGIC obs: a marca lenovo aparecia duas vezes, neste caso é preciso juntar essas duas vezes que lenovo aparece, neste caso eu uso "case when marca = 'lenovo' then 'Lenovo' else marca end as marca_ajustada,"
-- MAGIC

-- COMMAND ----------

select

case when marca = 'lenovo' then 'Lenovo' 
  else marca 
end as marca_ajustada,
avg(preco_atual_real) as media_preco_real
from vw_notebooks_vendidos 
group by 
case when marca = 'lenovo' then 'Lenovo' 
  else marca 
end
order by 2 desc

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Participação das Memórias(DDR3, DDR4 e DDR5)
-- MAGIC
-- MAGIC obs: foi preciso seguir o mesmo modelo do anterior, pois apareciam mais de uma opção com de memérias ram para ddr3 e ddr4

-- COMMAND ----------

select
case when ram_type = 'LPDDR3' then 'DDR3'
     when ram_type in('LPDDR4', 'LPDDR4X') then 'DDR4'
else ram_type end as tipo_memoria_ajustado,

avg(preco_atual_real) as media_preco_real
from vw_notebooks_vendidos 
group by 

case when ram_type = 'LPDDR3' then 'DDR3'
     when ram_type in('LPDDR4', 'LPDDR4X') then 'DDR4'
else ram_type end

order by 2 desc

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Soma das Mémórias e sua representação no total

-- COMMAND ----------

select
case when ram_type = 'LPDDR3' then 'DDR3'
     when ram_type in('LPDDR4', 'LPDDR4X') then 'DDR4'
else ram_type end as tipo_memoria_ajustado,

sum(preco_atual_real) as soma_preco_real
from vw_notebooks_vendidos 
group by 

case when ram_type = 'LPDDR3' then 'DDR3'
     when ram_type in('LPDDR4', 'LPDDR4X') then 'DDR4'
else ram_type end

order by 2 desc
