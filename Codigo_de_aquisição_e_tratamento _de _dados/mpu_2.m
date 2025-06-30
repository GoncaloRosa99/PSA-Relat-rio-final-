clear; clc; close all;

% CONFIGURAÇÃO DA PORTA SERIAL
porta = "COM8";  % Substitui pela tua COM
baudrate = 115200;
s = serialport(porta, baudrate);
configureTerminator(s, "LF");  % O ESP usa Serial.println, que envia LF
flush(s);

disp("A iniciar leitura em tempo real do MPU6050...");
duration = 30;   % Tempo total em segundos
t0 = tic;

% Vetores para armazenar dados
acX = [];
acY = [];
acZ = [];
tempo = [];

% Configuração das figuras com subplots
figure;

subplot(3,1,1);
hX = animatedline('Color', 'r');
title('Aceleração X');
ylabel('Aceleração (m/s^2)');
grid on;
xlim([0 duration]);
ylim([-20 20]);

subplot(3,1,2);
hY = animatedline('Color', 'g');
title('Aceleração Y');
ylabel('Aceleração (m/s^2)');
grid on;
xlim([0 duration]);
ylim([-20 20]);

subplot(3,1,3);
hZ = animatedline('Color', 'b');
title('Aceleração Z');
xlabel('Tempo (s)');
ylabel('Aceleração (m/s^2)');
grid on;
xlim([0 duration]);
ylim([-20 20]);

% LOOP DE LEITURA
while toc(t0) < duration
    if s.NumBytesAvailable > 0
        linha = readline(s);

        % Procurar por linha no formato: Sample i: X=... Y=... Z=... t=...
        tokens = regexp(linha, 'X=([-+]?[0-9]*\.?[0-9]+)\s+Y=([-+]?[0-9]*\.?[0-9]+)\s+Z=([-+]?[0-9]*\.?[0-9]+)\s+t=([0-9]+)', 'tokens');

        if ~isempty(tokens)
            valores = str2double(tokens{1});
            acX(end+1) = valores(1);
            acY(end+1) = valores(2);
            acZ(end+1) = valores(3);
            tempo(end+1) = valores(4) / 1000;  % converter t de ms para s

            % Atualizar cada subplot
            subplot(3,1,1);
            addpoints(hX, tempo(end), acX(end));
            drawnow limitrate;

            subplot(3,1,2);
            addpoints(hY, tempo(end), acY(end));
            drawnow limitrate;

            subplot(3,1,3);
            addpoints(hZ, tempo(end), acZ(end));
            drawnow limitrate;
        end
    end
end
% Filtragem usando média móvel
windowSize = 5;
acX_filt = movmean(acX, windowSize);
acY_filt = movmean(acY, windowSize);
acZ_filt = movmean(acZ, windowSize);

% Plot final com dados filtrados
figure;
subplot(3,1,1);
plot(tempo, acX_filt, 'r');
title('Aceleração X (filtrada)');
ylabel('Aceleração (m/s^2)');
grid on;

subplot(3,1,2);
plot(tempo, acY_filt, 'g');
title('Aceleração Y (filtrada)');
ylabel('Aceleração (m/s^2)');
grid on;

subplot(3,1,3);
plot(tempo, acZ_filt, 'b');
title('Aceleração Z (filtrada)');
xlabel('Tempo (s)');
ylabel('Aceleração (m/s^2)');
grid on;

disp("Aquisição concluída.");
%%
%% CALIBRAR OFFSET (BIAS) COM SENSOR PARADO
% Define o intervalo inicial onde o sensor está em repouso para calcular bias
t_calib_start = 0;      % tempo inicial do período parado
t_calib_end = 2;        % tempo final do período parado

% Encontrar índices de calibração
idx_calib_start = find(tempo >= t_calib_start, 1, 'first');
idx_calib_end = find(tempo <= t_calib_end, 1, 'last');

if isempty(idx_calib_start) || isempty(idx_calib_end) || idx_calib_start >= idx_calib_end
    error('Intervalo de calibração inválido: verifique t_calib_start e t_calib_end.');
end

% Calcular bias médio em cada eixo no intervalo parado
biasX = mean(acX_filt(idx_calib_start:idx_calib_end));
biasY = mean(acY_filt(idx_calib_start:idx_calib_end));
biasZ = mean(acZ_filt(idx_calib_start:idx_calib_end));

% Corrigir as acelerações filtradas removendo bias
acX_corr = acX_filt - biasX;
acY_corr = acY_filt - biasY;
acZ_corr = acZ_filt - biasZ;

%DEFINIR INTERVALO POR TEMPO (SEGUNDOS)
t_start = 2;   % tempo inicial em s
t_end = 8;       % tempo final em s

% Encontrar índices mais próximos no vetor de tempo
idx_start = find(tempo >= t_start, 1, 'first');
idx_end = find(tempo <= t_end, 1, 'last');

% Garantir que os índices são válidos
if isempty(idx_start) || isempty(idx_end) || idx_start >= idx_end
    error('Intervalo de tempo inválido: verifique t_start e t_end.');
end

% Extrair intervalo desejado corrigido
tempo_sel = tempo(idx_start:idx_end);
acX_sel = acX_corr(idx_start:idx_end);
acY_sel = acY_corr(idx_start:idx_end);
acZ_sel = acZ_corr(idx_start:idx_end);

% Calcular dt real do intervalo
dt_sel = diff(tempo_sel);

% Inicializar vetores de velocidade e posição para o intervalo
velX_sel = zeros(size(acX_sel));
velY_sel = zeros(size(acY_sel));
velZ_sel = zeros(size(acZ_sel));

posX_sel = zeros(size(acX_sel));
posY_sel = zeros(size(acY_sel));
posZ_sel = zeros(size(acZ_sel));

% Integração com dt real do intervalo
for i = 2:length(tempo_sel)
    velX_sel(i) = velX_sel(i-1) + acX_sel(i-1) * dt_sel(i-1);
    velY_sel(i) = velY_sel(i-1) + acY_sel(i-1) * dt_sel(i-1);
    velZ_sel(i) = velZ_sel(i-1) + acZ_sel(i-1) * dt_sel(i-1);

    posX_sel(i) = posX_sel(i-1) + velX_sel(i-1) * dt_sel(i-1);
    posY_sel(i) = posY_sel(i-1) + velY_sel(i-1) * dt_sel(i-1);
    posZ_sel(i) = posZ_sel(i-1) + velZ_sel(i-1) * dt_sel(i-1);
end

% Conversão para mm/s e mm
velX_sel_mm = velX_sel * 1000;
velY_sel_mm = velY_sel * 1000;
velZ_sel_mm = velZ_sel * 1000;

posX_sel_mm = posX_sel * 1000;
posY_sel_mm = posY_sel * 1000;
posZ_sel_mm = posZ_sel * 1000;

% PLOTS DAS VELOCIDADES EM mm/s
figure;
subplot(3,1,1);
plot(tempo_sel, velX_sel_mm, 'r');
title(sprintf('Velocidade X (%.1f-%.1f s)', t_start, t_end));
ylabel('Velocidade (mm/s)');
grid on;

subplot(3,1,2);
plot(tempo_sel, velY_sel_mm, 'g');
title(sprintf('Velocidade Y (%.1f-%.1f s)', t_start, t_end));
ylabel('Velocidade (mm/s)');
grid on;

subplot(3,1,3);
plot(tempo_sel, velZ_sel_mm, 'b');
title(sprintf('Velocidade Z (%.1f-%.1f s)', t_start, t_end));
xlabel('Tempo (s)');
ylabel('Velocidade (mm/s)');
grid on;

% PLOTS DAS POSIÇÕES EM mm
figure;
subplot(3,1,1);
plot(tempo_sel, posX_sel_mm, 'r');
title(sprintf('Posição X (%.1f-%.1f s)', t_start, t_end));
ylabel('Posição (mm)');
grid on;

subplot(3,1,2);
plot(tempo_sel, posY_sel_mm, 'g');
title(sprintf('Posição Y (%.1f-%.1f s)', t_start, t_end));
ylabel('Posição (mm)');
grid on;

subplot(3,1,3);
plot(tempo_sel, posZ_sel_mm, 'b');
title(sprintf('Posição Z (%.1f-%.1f s)', t_start, t_end));
xlabel('Tempo (s)');
ylabel('Posição (mm)');
grid on;
