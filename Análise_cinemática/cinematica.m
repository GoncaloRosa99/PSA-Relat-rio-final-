clear; clc;

disp("==== Cálculo da Cinemática do Robô Delta ====")
opcao = input("Escolha o tipo de cinemática (1 = Inversa | 2 = Direta): ");

if opcao == 1
    % Cinemática Inversa: posição -> ângulos
    x = input("Coordenada x = ");
    y = input("Coordenada y = ");
    z = input("Coordenada z = ");
    Pp = [x; y; z];
    theta = Inversa_Delta(Pp);
    fprintf("\nÂngulos calculados (graus):\n")
    fprintf("θ₁ = %.2f°\nθ₂ = %.2f°\nθ₃ = %.2f°\n", theta(1), theta(2), theta(3));
    
    % Mostrar snapshot
    plot_snapshot(Pp, theta);

elseif opcao == 2
    % Cinemática Direta: ângulos -> posição
    t1 = input("Ângulo θ₁ (graus) = ");
    t2 = input("Ângulo θ₂ (graus) = ");
    t3 = input("Ângulo θ₃ (graus) = ");
    theta = [t1; t2; t3];
    Pp = Direta_Delta(theta);
    fprintf("\nPosição calculada da plataforma móvel (m):\n")
    fprintf("x = %.3f m\ny = %.3f m\nz = %.3f m\n", Pp(1), Pp(2), Pp(3));
    
    % Mostrar snapshot
    plot_snapshot(Pp, theta);

else
    disp("Opção inválida.")
end
