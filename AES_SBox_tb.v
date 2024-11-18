module AES_SBox_tb();
    // Señales de prueba
    reg CLOCK_50;          // Señal de reloj de 50MHz
    reg [9:0] SW;          // Interruptores de entrada
    reg KEY;               // Botón de reset
    wire [9:0] LEDR;       // LEDs de salida
    
    // Almacenamiento de datos de prueba
    reg [7:0] test_data;       // Datos de prueba para encriptar
    reg [7:0] encrypted_data;  // Datos encriptados
    
    // Instanciación del DUT (Device Under Test)
    AES_SBox dut (
        .CLOCK_50(CLOCK_50),
        .SW(SW),
        .LEDR(LEDR),
        .KEY(KEY)
    );
    
    // Generación del reloj
    always begin
        #10 CLOCK_50 = ~CLOCK_50;  // Genera un reloj de 50MHz
    end
    
    // Procedimiento de prueba
    initial begin
        // Inicialización de señales
        CLOCK_50 = 0;
        SW = 10'b0;
        KEY = 1;
        
        // Prueba 1: Reset
        #100 KEY = 0;  // Activa el reset
        #50 KEY = 1;   // Libera el reset
        
        // Prueba 2: Encriptación
        #100;
        test_data = 8'hA5;       // Datos de prueba a encriptar
        SW[9] = 1;               // Modo encriptación
        SW[7:0] = test_data;     // Datos de entrada
        #100;
        encrypted_data = LEDR[7:0];  // Almacena los datos encriptados
        
        // Prueba 3: Almacenamiento
        #100;
        if (encrypted_data != LEDR[7:0])
            $display("Error: Fallo en el almacenamiento de datos");
            
        // Esta sección del test bench se realiza una prueba de desencriptación.
        // Establece el interruptor SW[9] en 0 para indicar el modo de desencriptación y espera 100 unidades de tiempo.
        // Luego, verifica si la salida LEDR[7:0] coincide con los datos de prueba esperados (test_data).
        // Si la salida no coincide, muestra un mensaje de error indicando un fallo en la desencriptación.
        
        // Prueba 4: Desencriptación
        #100;
        SW[9] = 0;    // Modo desencriptación
        #100;
        if (LEDR[7:0] != test_data)
            $display("Error: Fallo en la desencriptación");
            
        // Fin de la simulación
        #100;
        $display("Simulación completada");
        $finish;
    end
    
    // Monitor
    always @(posedge CLOCK_50) begin
        $display("Tiempo=%0t Modo=%b Datos=0x%h Salida=0x%h", 
                 $time, SW[9], SW[7:0], LEDR[7:0]);
    end
    
endmodule