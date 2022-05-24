function [A,B]=plot_graph(INPUT_FILE, TIPO_EXIBICAO, INPUT_FILE2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ARGUMENTOS:
% INPUT_FILE: arquivo de dados
%
% TIPO EXIBICAO:
% 'sensors':    Plot sensors graph
% 'attention':  Plot attention graph
% 'features':   Plot features graph
%
%  INPUT_FILE2: arquivo de dados complementar
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RETORNO
% Nenhum. Cria figure para exibi��o do gr�fico
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Configura��es independentes do tipo de gr�fico
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

XTICKS = [1 45 90 135 180];     % Linhas que ser�o colocadas no grid em X
NUM_XTICKS = 44;                % O nome dos sensores no eixo x somente sera exibido no grafico a cada NUM_XTICKS valores
AJUSTE_TEXTO_Z=1.5;             % Ajuste fino da posicao do texto do nome dos sensores com relacao a Z (+ para cima, - para baixo). Valor nao precisa ser inteiro.
AJUSTE_TEXTO_X=1;               % Ajuste fino da posicao do texto do nome dos sensores com relacao a X (+ para direita, - para esquerda). Valor nao precisa ser inteiro.
TMIN = 1;                       % TMIN da observacao (ignora tempos antes disso). M�nimo: 1
TMAX = 110;                      % Tempo final da observa��o (0: at� a �ltima linha do arquivo)
T_INCR = 5;                     % Somente um a cada T_INCR serao exibidos no exio do tempo (y)
                                %  ou seja: [TMIN:T_INCR:TMAX]. 0: apenas primeiro e �ltimo
FONTSIZE = 12;                  % Tamanho da fonte utilizada
ESCALA_EIXOS = [0.5 2 0.2];     % [X Y Z]
REMOVER_OFFSET_TEMPO = 1;       % Faz t=t-t(0) para todo tempo t
PONTO_VISTA = 0;                % Ponto de vista dos graficos. 0:perspectiva 1:vista lateral
SUPRIMIR_COLORBAR=0;            % 0:n�o suprime. A exibi��o ou n�o ser� feita de acordo com o tipo de gr�fico
                                % 1:suprime o colorbar de todos os gr�fios que tenham                       
NUM_FEATURES=8;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Verificando argumentos e tipo de gr�fico selecionado
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%nargin stores the number of arguments
%nargchk returns apropriate error message
%error( nargchk( 1, 2, nargin ) ); 
T_SENSORS = strcmp(TIPO_EXIBICAO, 'sensors');
T_SENSORS_INV = strcmp(TIPO_EXIBICAO, 'sensors_inv');
T_FEATURES = strcmp(TIPO_EXIBICAO, 'features');
T_FEATURES_INV = strcmp(TIPO_EXIBICAO, 'features_inv');
T_ATTENTION = strcmp(TIPO_EXIBICAO, 'attention');
T_SALIENCE = strcmp(TIPO_EXIBICAO, 'salience');
T_WINNER = strcmp(TIPO_EXIBICAO, 'winner');
if (T_SENSORS==0 & T_SENSORS_INV==0 & T_FEATURES==0 & T_ATTENTION==0 & T_WINNER==0 & T_SALIENCE==0 & T_FEATURES_INV==0)
    error('Tipo de exibi��o incorreto. Finalizando.');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Configura��es dependentes edo tipo de gr�fico
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (T_SENSORS)
    ZDIR = 0;                       %Direção de Z é normal ou reversa?  0:normal, 1:reversa
    TIPO_GRAFICO = 0;               %0:mesh; 1:bars; 2:mesh por linhas
    TIPO_Z = 2;                     %Tipo de exibição de Z. 0:[0, 1] 1:auto (min e max determinados da matriz)
    NORMALIZAR_DADOS = 1;           %Os dados do gráfico devem ser normalizados de acordo 
                                    %   com os valores mínimos e máximos de cada sensor? 0:não 1:sim.    
    TITULO = ' ';%'Sensors';             %Título do gráfico
    SHOW_COLORBAR = 1;              %Exibe a barra de cores no gráfico? 0:nao 1:sim
    NOME_FEATURES = 1;              %Exibe nomes ou indices no eixo das features? 0:indices 1:nomes
elseif (T_SENSORS_INV)
    ZDIR = 1;                       %Direção de Z é normal ou reversa?  0:normal, 1:reversa
    TIPO_GRAFICO = 5;               %0:mesh; 1:bars; 2:mesh por linhas
    TIPO_Z = 2;                     %Tipo de exibição de Z. 0:[0, 1] 1:auto (min e max determinados da matriz)
    NORMALIZAR_DADOS = 1;           %Os dados do gráfico devem ser normalizados de acordo 
                                    %   com os valores mínimos e máximos de cada sensor? 0:não 1:sim.    
    TITULO = ' ';%'Sensors';             %Título do gráfico
    SHOW_COLORBAR = 1;              %Exibe a barra de cores no gráfico? 0:nao 1:sim
    NOME_FEATURES = 1;              %Exibe nomes ou indices no eixo das features? 0:indices 1:nomes    
elseif (T_ATTENTION)
    ZDIR = 0;                       %Direção de Z é normal ou reversa?  0:normal, 1:reversa
    TIPO_GRAFICO = 0;               %0:mesh; 1:bars; 2:mesh por linhas
    TIPO_Z = 2;                     %Tipo de exibição de Z. 
                                    %   0:[0, 1] 
                                    %   1:[0, AUTO] (max determinado da matriz)
                                    %   2:[AUTO, AUTO] (min e max determinados da matriz)
    NORMALIZAR_DADOS = 1;           %Os dados do gráfico devem ser normalizados de acordo 
                                    %   com os valores mínimos e máximos de cada sensor? 0:não 1:sim.     
    TITULO = ' ';%'Attention';           %Título do gráfico   
    SHOW_COLORBAR = 1;              %Exibe a barra de cores no gráfico? 0:nao 1:sim
    NOME_FEATURES = 1;              %Exibe nomes ou indices no eixo das features? 0:indices 1:nomes
    
elseif(T_FEATURES)
    ZDIR = 0;                       %Direção de Z é normal ou reversa?  0:normal, 1:reversa
    TIPO_GRAFICO = 0;               %0:mesh; 1:bars; 2:mesh por linhas
    TIPO_Z = 2;                     %Tipo de exibição de Z. 0:[0, 1] 1:auto (min e max determinados da matriz)
    NORMALIZAR_DADOS = 1;           %Os dados do gráfico devem ser normalizados de acordo 
                                    %   com os valores mínimos e máximos de cada sensor? 0:não 1:sim.
    TITULO = ' ';%'Features';            %Título do gráfico   
    SHOW_COLORBAR = 1;              %Exibe a barra de cores no gráfico? 0:nao 1:sim
    NOME_FEATURES = 1;              %Exibe nomes ou indices no eixo das features? 0:indices 1:nomes
                                    % Eixo X invertido
elseif(T_FEATURES_INV)              
    ZDIR = 0;                       %Direção de Z é normal ou reversa?  0:normal, 1:reversa
    TIPO_GRAFICO = 5;               %0:mesh; 1:bars; 2:mesh por linhas
    TIPO_Z = 2;                     %Tipo de exibição de Z. 0:[0, 1] 1:auto (min e max determinados da matriz)
    NORMALIZAR_DADOS = 1;           %Os dados do gráfico devem ser normalizados de acordo 
                                    %   com os valores mínimos e máximos de cada sensor? 0:não 1:sim.
    TITULO = ' ';%'Features';            %Título do gráfico   
    SHOW_COLORBAR = 1;              %Exibe a barra de cores no gráfico? 0:nao 1:sim
    NOME_FEATURES = 1;              %Exibe nomes ou indices no eixo das features? 0:indices 1:nomes  
elseif(T_SALIENCE)
    ZDIR = 0;                       %Direção de Z é normal ou reversa?  0:normal, 1:reversa
    TIPO_GRAFICO = 4;               %0:mesh; 1:bars; 2:mesh por linhas
    TIPO_Z = 4;                     %Tipo de exibição de Z. 0:[0, 1] 1:auto (min e max determinados da matriz)
    NORMALIZAR_DADOS = 1;           %Os dados do gráfico devem ser normalizados de acordo 
                                    %   com os valores mínimos e máximos de cada sensor? 0:não 1:sim.
    TITULO = ' ';'Salience map';    %Título do gráfico   
    SHOW_COLORBAR = 1;              %Exibe a barra de cores no gráfico? 0:nao 1:sim
    NOME_FEATURES = 1;              %Exibe nomes ou indices no eixo das features? 0:indices 1:nomes
elseif (T_WINNER)
    ZDIR = 0;                       %Direção de Z é normal ou reversa?  0:normal, 1:reversa
    TIPO_GRAFICO = 3;               %0:mesh; 1:bars; 2:mesh por linhas; 3: pontos
    TIPO_Z = 3;                     %Tipo de exibição de Z. 0:[0, 1] 1:auto (min e max determinados da matriz)
    NORMALIZAR_DADOS = 1;           %Os dados do gráfico devem ser normalizados de acordo 
                                    %   com os valores mínimos e máximos de cada sensor? 0:não 1:sim.       
    TITULO = ' ';%'Winner';         %Título do gráfico   
    SHOW_COLORBAR = 0;              %Exibe a barra de cores no gráfico? 0:nao 1:sim
    NOME_FEATURES = 0;              %Exibe nomes ou indices no eixo das features? 0:indices 1:nomes
end

if (PONTO_VISTA==1) 
    SUPRIMIR_COLORBAR = 1;     
end
if (SUPRIMIR_COLORBAR==1)
    SHOW_COLORBAR=0;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARTE 1 - LEITURA DO ARQUIVO DE DADOS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fid = fopen(INPUT_FILE,'rt');
if (fid == -1) 
    disp('File not found');
end
num_linhas = 0;
semaforo = 0;
linha = 0;
while (semaforo==0),
   tline = fgets(fid);                      %Faz leitura de uma linha inteira (qualquer n�mero de dimens�es) para tline
   if (tline == -1)                         %Verifica se EOF
       semaforo = 1;
   else                                     %Linha v�lida de dados 
      linha = linha+1;
      if (linha == 1)                       %A primeira linha armazena os nomes dos sensores
          nomes = strread(tline, '%s');
          [num_colunas lixo] = size(nomes);
          dados = zeros(num_linhas,num_colunas);
      elseif (linha == 2)                   %A segunda linha armazena os valores m�nimos dos sensores
          val_min = strread(tline);
      elseif (linha == 3)                   %A terceira linha armazena os valores m�xmos dos sensores
          val_max = strread(tline);
      else                                  %Da quarta � �ltima linha encontram-se os dados do gr�fico   
          %tline2 = strtrim(tline);          %Remove espa�os (' ') do in�cio e fim do string (remo��o de bug)
          %linhatemp = strread(tline2);      %Quebra o string em array utilizando ' ' como delimitador
          linhatemp = strread(tline);        %Quebra o string em array utilizando ' ' como delimitador
          %format shortG;
          dados(linha-3, 1) = linhatemp(1); %A 1a coluna armazena o numero das iteracoes (tempo)
          for (coluna=2:1:num_colunas)
            if (NORMALIZAR_DADOS==0)        %Dados sem normaliza��o:
                dados(linha-3, coluna) = linhatemp(coluna);
            else                            %Dados normalizados:
                dados(linha-3, coluna) = ((linhatemp(coluna)-val_min(coluna))/(val_max(coluna)-val_min(coluna)));
            end
          end
      end        
   end
end
fclose(fid);


if (T_SALIENCE==1)                                 %Precisa capturar dados de um arquivo auxiliar
    fid = fopen(INPUT_FILE2,'rt');
    num_linhas = 0;
    semaforo = 0;
    linha = 0;
    while (semaforo==0),
        tline = fgets(fid);                      %Faz leitura de uma linha inteira (qualquer n�mero de dimens�es) para tline
        if (tline == -1)                         %Verifica se EOF
            semaforo = 1;
        else                                     %Linha v�lida de dados 
            linha = linha+1;
            if (linha == 1)                       %A primeira linha armazena os nomes dos sensores
                nomes_aux = strread(tline, '%s');
                [num_colunas lixo] = size(nomes_aux);
                dados_aux = zeros(num_linhas,num_colunas);
            elseif (linha == 2)                   %A segunda linha armazena os valores m�nimos dos sensores
                val_min_aux = strread(tline);
            elseif (linha == 3)                   %A terceira linha armazena os valores m�xmos dos sensores
                val_max_aux = strread(tline);
            else                                  %Da quarta � �ltima linha encontram-se os dados do gr�fico    
                %tline2 = strtrim(tline);          %Remove espa�os (' ') do in�cio e fim do string (remo��o de bug)
                %linhatemp = strread(tline2);      %Quebra o string em array utilizando ' ' como delimitador
                linhatemp = strread(tline);
                %format shortG;
                dados_aux(linha-3, 1) = linhatemp(1); %A 1a coluna armazena o numero das iteracoes (tempo)
                for (coluna=2:1:num_colunas)
                    if (NORMALIZAR_DADOS==0)        %Dados sem normaliza��o:
                        dados_aux(linha-3, coluna) = linhatemp(coluna);
                    else                            %Dados normalizados:
                        dados_aux(linha-3, coluna) = ((linhatemp(coluna)-val_min_aux(coluna))/(val_max_aux(coluna)-val_min_aux(coluna)));
                    end
                end
            end        
        end
    end
    fclose(fid);
end

[num_linhas lixo] = size(dados);
if (TMAX==0)
    TMAX = num_linhas;
end
if (T_INCR==0)
    T_INCR = num_linhas-1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARTE 2 - EXIBI��O DOS DADOS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARTE 2.1 - CONSTRU��O DAS CURVAS COM OS DADOS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clf;
cla;
figptr = gcf;
set(gcf, 'color', 'white');                             %Padroniza o background branco para as figuras
%figureptr = figure;
if (PONTO_VISTA==1)
    set(gcf, 'Position', [0 0 600 100]);
end

%--- Esse bloco corrige um bug quando o usuario usa TMAX maior que o possivel
if (T_WINNER==0)
    if (TMAX > num_linhas)
        disp(' ');
        disp('ATENCAO: O tempo maximo estabelecido pelo usuario esta acima do .');
        disp('   numero de amostragens no arquivo. TMAX foi alterado para o  ');
        disp('   valor maximo possivel:');
        TMAX
        TMAX = num_linhas
    end
end
%--- fim do bug


if (TIPO_GRAFICO==0)                                    %GR�FICO DE SUPERF�CIE
   [X,Y] = meshgrid(1:num_colunas-1, TMIN:TMAX);
   surf(X, Y, dados(TMIN:TMAX, 2:num_colunas));
   %surf(X, Y, dados(TMIN:TMAX, 2:num_colunas),'EdgeColor', 'none', 'FaceColor','interp','CDataMapping', 'scaled');    %Utiliza superf�cie colorida
   %contour3(dados);
   %meshc(dados);                                       %Utiliza wireframe
   %meshc(X, Y, dados(TMIN:TMAX, 2:num_colunas));       %Utiliza superf�cie colorida
   shading interp                                       %Visualiza��o cores interpolada
   %shading flat                                        %Visualiza��o cores em camadas
   %colormap(gray);                                     %Mapa de cores em n�veis de cinza
   set(gca,'XDir', 'normal');                          %Necess�rio inverter a dire��o de X
elseif (TIPO_GRAFICO==5)                                %GR�FICO DE SUPERF�CIE COM EIXO X INVERTIDO
   [X,Y] = meshgrid(1:num_colunas-1, TMIN:TMAX);
   surf(X, Y, dados(TMIN:TMAX, 2:num_colunas));
   set(gca, 'XDir', 'reverse');
   shading interp                                       %Visualiza��o cores interpolada
 elseif (TIPO_GRAFICO==1)                                %GR�FICO DE BARRAS
    bar3(dados(TMIN:TMAX, 2:num_colunas));
    set(gca,'XDir', 'normal');                          %Necess�rio inverter a dire��o de X
    set(gca,'YDir', 'normal');                          %Necess�rio inverter a dire��o de Y
elseif (TIPO_GRAFICO==2)                                %GR�FICO DE M�LTIPLAS SUPERF�CIES EM LINHA
    hold on;
    for (i=1:num_colunas-1)
        [X,Y] = meshgrid(i:i+1, TMIN:TMAX);
        dadoduplo = [dados(TMIN:TMAX, i+1) dados(TMIN:TMAX, i+1)];
        surf(X, Y, dadoduplo);
    end
    hold off;
    set(gca,'XDir', 'normal');                          %Necess�rio inverter a dire��o de X
elseif (TIPO_GRAFICO==3)                                %GR�FICO WINNERS
        %dados2(feature, tempo) = altura (fixa!!)
        dados2=zeros(NUM_FEATURES, TMAX)
        for (i=1:1:TMAX)
            tempo(i) = i-1;
        end
        for (f=0:1:NUM_FEATURES-1)
            f
            [linha_com_dado b]=find(dados(:,2)==f)
            dados2(f+1, dados(linha_com_dado,1)+1)=1
        end
        size(tempo)
        size(dados2)
    h = bar3(tempo, dados2');
    %set(h,'facecolor','blue')
    set(gca,'XDir', 'normal');                          %Necess�rio inverter a dire��o de X
    set(gca,'YDir', 'normal');                          %Necess�rio inverter a dire��o de Yt
elseif (TIPO_GRAFICO==4)                                    %GR�FICO DE SALIENCIA
   [X,Y] = meshgrid(1:num_colunas-1, TMIN:TMAX);
   surf(X, Y, dados(TMIN:TMAX, 2:num_colunas).*dados_aux(TMIN:TMAX, 2:num_colunas));
   %surf(X, Y, dados(TMIN:TMAX, 2:num_colunas),'EdgeColor', 'none', 'FaceColor','interp','CDataMapping', 'scaled');    %Utiliza superf�cie colorida
   %contour3(dados);
   %meshc(dados);                                       %Utiliza wireframe
   %meshc(X, Y, dados(TMIN:TMAX, 2:num_colunas));       %Utiliza superf�cie colorida
   shading interp                                       %Visualiza��o cores interpolada
   %shading flat                                        %Visualiza��o cores em camadas
   %colormap(gray);                                     %Mapa de cores em n�veis de cinza
   set(gca,'XDir', 'normal');                          %Necess�rio inverter a dire��o de X
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARTE 2.2 - PREPARA��O DOS DADOS COMPLEMENTARES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set(0, 'DefaultAxesFontName', 'Arial');                 %Configura tipo da fonte
set(gca,'FontSize',FONTSIZE);                           %Configura tamanho da fonte
xlabel('Direction Feature Map');					
if (PONTO_VISTA==0)
    ylabel('Time ');
end
zlabel('Value');
title (TITULO);                                         %T�tulo do gr�fico
if (ZDIR==1)
    set(gca, 'Zdir', 'reverse');
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARTE 2.3 - CONFIGURA��ES DO EIXO X
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--- Esse bloco corrige um bug quando o usuario usa NUM_XTICKS maior que o possivel
if (NUM_XTICKS > num_colunas)
    disp(' ');
    disp('ATENCAO: A configuracao corrente solicita que um a cada NUM_XTICKS ');
    disp('   sensores tenham seu nome exibido no eixo x. Contudo, o valor de ');
    disp('   NUM_XTICKS eh maior que o numero de sensores. A variavel foi ');
    disp('   alterada para exibir o nome de todos os sensores:');
    NUM_XTICKS
    NUM_XTICKS = 1
end
%--- fim do bug


if (PONTO_VISTA==0)
    if (NOME_FEATURES==1)
        set(gca,'XTick',0:NUM_XTICKS:num_colunas-2);                 %Configura o n�mero de ticks no eixo X (nem todos ser�o exibidos)
        set(gca,'XTickLabel',nomes(2:NUM_XTICKS:num_colunas));       %Configura os nomes das features recebidas como ticks
    elseif (NOME_FEATURES==0)
        set(gca,'XTick',1:NUM_XTICKS:NUM_FEATURES);                  %Configura o n�mero de ticks no eixo X (nem todos ser�o exibidos)
        set(gca,'XTickLabel',num2str([1:NUM_XTICKS:NUM_FEATURES]'));             %Configura os nomes das features recebidas como ticks
    end
else
    set(gca,'XTickLabel',[]);
end

%Rota��o: in�cio --------------------------------
rot = 90;                                               %Textos no eixo das features devem ser rotacionados em 90o
a=get(gca,'XTickLabel');                                %  como n�o h� fun��o pronta no Matlab para isso, � preciso
set(gca,'XTickLabel',[]);                               %  fazer manualmente...
b=get(gca,'XTick');
c=get(gca,'YTick');
if (TIPO_Z==2)                                          %Se grafico pode ter min!=0, ent�o a posi��o onde o texto vai ser colocado
                                                        %   no eixo X precisa considerar esse offset (ZMIN)
    temp = dados(:,2:num_colunas);                      %Colhe todos os dados da matriz principal
    min_vector = min(temp);                             %Determina o valor m�nimo em cada coluna (retorna vetor)
    max_vector = max(temp);
    if (ZDIR==0)
        MULT = min(min_vector);                             %Determina o valor m�nimo nesse vetor (retorna n�mero)
    elseif (ZDIR==1) 
        MULT = max(max_vector);
    end
    MULT_VECTOR = MULT*ones(length(b),1);                  %Cria um vetor n-dimensional com esse n�mero (1 para cada feature em X)
    % text (a,b,c,1)
    % a+: shift na direcao do eixo x, sentido positivo
    % b+: shift na direcao do eixo Z, sentido positivo
    th=text(b+AJUSTE_TEXTO_X,repmat(c(1)-.1*(c(2)-c(1)),length(b),1)+AJUSTE_TEXTO_Z,MULT_VECTOR,a,'HorizontalAlignment','right','rotation',rot, 'FontSize', FONTSIZE);
else
    e = repmat(c(1)-.1*(c(2)-c(1)),length(b),1);
    if (TIPO_GRAFICO==3) %%%%%%%% Estou na d�vida aqui... Mas isso corrige bug.
        e = e.*(1/4);
    end
    th=text(b,e,a,'HorizontalAlignment','right','rotation',rot, 'FontSize', FONTSIZE);
end
%Rota��o: fim -----------------------------------
if (PONTO_VISTA==0)
    set(gca,'XTick',XTICKS);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARTE 2.4 - CONFIGURA��ES DO EIXO Y
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (TIPO_GRAFICO==3)
    set(gca,'YTick',0:T_INCR:TMAX);                         %Exibe os ticks de tempo selecionados pelo usu�rio no in�cio deste arquivo
else
    set(gca,'YTick',1:T_INCR:TMAX);                         %Exibe os ticks de tempo selecionados pelo usu�rio no in�cio deste arquivo
end
if (TIPO_GRAFICO==3)
    YLABEL = tempo(1:T_INCR:TMAX);                       %Utiliza como label dos tempos os valores de itera��o recebidos
else
    YLABEL = dados([1:T_INCR:num_linhas],1);            %Utiliza como label dos tempos os valores de itera��o recebidos
end
if (REMOVER_OFFSET_TEMPO==1)                            %Remove o offset de todos os tempos, fazendo: t_{atual} = t_{atual} - t0
    [num_yticks, lixo] = size(YLABEL);
    offset = YLABEL(1);
    for (i=1:1:num_yticks)
        YLABEL(i) = YLABEL(i) - offset;
    end
end
set(gca,'YTickLabel',YLABEL);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARTE 2.5 - CONFIGURA��ES DO EIXO Z
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (TIPO_Z==3)
    if (PONTO_VISTA==1)
        ZLABEL = {'0.00' '1.00'};                                 %Valores para os ticks min e max de z
    else
        ZLABEL = {'0' '1'};                                 %Valores para os ticks min e max de z
    end
    ZMAX = 1;
    ZMIN = 0;
elseif (TIPO_Z==0)
    ZLABEL = {'0' '100%'};                              %Valores para os ticks min e max de z
    ZMAX = 1;
    ZMIN = 0;
elseif (TIPO_Z==1)
    temp = dados(:,2:num_colunas);                      %Colhe todos os dados da matriz principal
    max_vector = max(temp);                             %Obt�m os valores m�ximos em cada coluna
    ZMAX = max(max_vector);                             %Obt�m o valor m�ximo dentre os elementos deste vetor
    ZMAX_LABEL = num2str(ZMAX);                         %Transforma para str
    if (PONTO_VISTA==1)
        ZMAX_LABEL = num2str(ZMAX, '%.2f');
    end
    ZLABEL = {'0'  ZMAX_LABEL};                         %Cria string com valores m�nimo e m�ximo
    ZMIN = 0;
elseif (TIPO_Z==2)
    temp = dados(:,2:num_colunas);                      %Colhe todos os dados da matriz principal
    max_vector = max(temp);                             %Obt�m os valores m�ximos em cada coluna
    min_vector = min(temp);
    ZMAX = max(max_vector);                             %Obt�m o valor m�ximo dentre os elementos deste vetor
    ZMIN = min(min_vector);
    if (ZMIN == ZMAX)
        ZMAX = ZMAX+1;
    end
    ZMAX_LABEL = num2str(ZMAX);                         %Transforma para str
    ZMIN_LABEL = num2str(ZMIN);
    if(PONTO_VISTA==1)
        ZMAX_LABEL = num2str(ZMAX,'%.2f');                         %Transforma para str
        ZMIN_LABEL = num2str(ZMIN,'%.2f');
    end
    ZLABEL = {ZMIN_LABEL  ZMAX_LABEL};                  %Cria string com valores m�nimo e m�ximo
elseif (TIPO_Z==4)
    temp = dados(:,2:num_colunas).*dados_aux(:,2:num_colunas);
    max1 = max(temp);
    ZMAX = max(max1);
    min1 = min(temp);
    ZMIN = min(min1);
    ZMAX_LABEL = num2str(ZMAX);                         %Transforma para str
    ZMIN_LABEL = num2str(ZMIN);
    if(PONTO_VISTA==1)
        ZMAX_LABEL = num2str(ZMAX,'%.2f');                         %Transforma para str
        ZMIN_LABEL = num2str(ZMIN,'%.2f');
    end
    ZLABEL = {ZMIN_LABEL  ZMAX_LABEL};                  %Cria string com valores m�nimo e m�ximo
end
set(gca,'ZTickLabel',ZLABEL);                           %Atribui o string para o tick no eixo Z
if (ZMIN==ZMAX)
    ZMAX = ZMAX+1;                                      %Remove bug de nao exibir quando todos os dados s�o iguais
end
set(gca,'ZTick',[ZMIN ZMAX]);                           %Exibe apenas os valores m�nimo e m�ximo para Z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARTE 2.6 - CONFIGURA��ES DAS VISTAS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ((TIPO_Z==0) | (TIPO_Z==3))
    ZMIN = 0;    
    ZMAX = 1;
elseif ((TIPO_Z==1) | (TIPO_Z==2))
    temp = dados(:,2:num_colunas);
    max1 = max(temp);
    ZMAX = max(max1);
    min1 = min(temp);
    ZMIN = min(min1);
elseif (TIPO_Z==4)
    temp = dados(:,2:num_colunas).*dados_aux(:,2:num_colunas);
    max1 = max(temp);
    ZMAX = max(max1);
    min1 = min(temp);
    ZMIN = min(min1);
end

if (ZMIN==ZMAX)
    ZMAX = ZMAX+1;
end

if (TIPO_GRAFICO==0)
    axis ([1 num_colunas-1 TMIN TMAX ZMIN ZMAX]);
elseif (TIPO_GRAFICO==1)
    axis ([0 num_colunas TMIN TMAX ZMIN ZMAX]);
elseif (TIPO_GRAFICO==2)
    axis ([1 num_colunas TMIN TMAX ZMAX ZMIN]); 
elseif (TIPO_GRAFICO==3)
    ylim([tempo(1)-1 max(tempo)+1]);
elseif (TIPO_GRAFICO==4)
    axis ([1 num_colunas-1 TMIN TMAX ZMIN ZMAX]);
elseif (TIPO_GRAFICO==5)
    axis ([1 num_colunas-1 TMIN TMAX ZMIN ZMAX]);
end
if (PONTO_VISTA==0)
    view(13,27);
elseif (PONTO_VISTA==1)
    view(90,0);
end
grid on;
pbaspect('manual');
pbaspect(ESCALA_EIXOS);
hold off;
if (SHOW_COLORBAR==1) 
    colorbar;
end


