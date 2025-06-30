clear all; clc; close all;

porta = "COM8";
s = serialport(porta, 115200);
configureTerminator(s, "CR");
flush(s);

%% Ignorar mensagens de boot
disp("A ignorar mensagens de boot...");
t0 = tic;
while toc(t0) < 4
    if s.NumBytesAvailable > 0
        readline(s);  % descarta linha de boot
    end
end

pause(0.5);  % garantir estabilidade

%% Inicialização segura
writeline(s, "G90"); readline(s); pause(0.3);       % Coordenadas absolutas
writeline(s, "G28"); readline(s); pause(1.0);       % Homing (se suportado)
writeline(s, "M17"); readline(s); pause(0.3);       % Ativar motores
writeline(s, "M17.1"); readline(s); pause(0.3);     % Modo Delta

%% Movimento para origem segura
disp("A mover para origem segura...");
writeline(s, "G1 X0 Y0 Z0 F25000"); readline(s); pause(1);


% Teste eixo Z negativo
% disp("Movimento em Z negativo");
% writeline(s, "G1 X-10 Y0 Z20 F25000"); readline(s); pause(2);
% 
% 
% Teste A1
% disp("Movimento para A1");
% writeline(s, "G1 X-112 Y-112 Z-30 F25000"); readline(s); pause(2);
%% Enviar UIM0 e capturar resposta mais recente
disp("A capturar última posição 'UIM'...");
last_uim = "";
t1 = tic;
while toc(t1) < 2
    writeline(s, "UIM0");
    pause(0.2);

    if s.NumBytesAvailable > 0
        line = readline(s);
        if contains(line, "UIM")
            last_uim = line;
        end
    end
end

% Desligar motores
 writeline(s, "M18"); readline(s); pause(0.5);





