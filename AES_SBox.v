module AES_SBox (
    input wire CLOCK_50,          // Reloj de 50 MHz
    input wire [9:0] SW,          // Interruptores de entrada
    output wire [9:0] LEDR,       // LEDs de salida
    input wire KEY                // Botón de reinicio
);

    // Señales internas
    wire [7:0] data_in;           // Datos de entrada
    wire [7:0] sbox_out;          // Salida de la S-box
    wire [7:0] control_out;       // Salida de control
    wire [7:0] led_data;          // Datos para los LEDs
    wire encrypt_mode;            // Modo de encriptación
    wire reset_raw;               // Señal de reinicio sin procesar
    wire debounced_reset;         // Señal de reinicio debounced

    // Memoria para almacenar datos encriptados
    reg [7:0] encrypted_data;
    
    // Asignaciones de señales
    assign data_in = SW[7:0];     // Asignar los primeros 8 bits de SW a data_in
    assign encrypt_mode = SW[9];  // Asignar el bit 9 de SW a encrypt_mode
    assign reset_raw = ~KEY;      // Invertir la señal del botón de reinicio

    // Instancia del debouncer
    debouncer reset_debounce (
        .clk_50MHz(CLOCK_50),     // Conectar el reloj de 50 MHz
        .btn_in(reset_raw),       // Conectar la señal de reinicio sin procesar
        .btn_out(debounced_reset) // Conectar la salida debounced
    );

    // Instancia de la S-box
    sbox_lookup sbox_inst (
        .encrypt(encrypt_mode),   // Conectar el modo de encriptación
        .address(encrypt_mode ? data_in : encrypted_data), // Dirección de entrada
        .data_out(sbox_out)       // Conectar la salida de la S-box
    );

    // Almacenar datos encriptados
    always @(posedge CLOCK_50) begin
        if (debounced_reset)
            encrypted_data <= 8'h00; // Reiniciar datos encriptados
        else if (encrypt_mode)
            encrypted_data <= sbox_out; // Almacenar salida de la S-box
    end

    // Selección de salida
    assign led_data = encrypt_mode ? sbox_out : 
                     (encrypted_data != 8'h00) ? sbox_out : data_in;
    
    // Asignaciones de salida a los LEDs
    assign LEDR[7:0] = led_data;  // Asignar datos a los primeros 8 LEDs
    assign LEDR[9] = encrypt_mode; // Asignar modo de encriptación al LED 9
    assign LEDR[8] = debounced_reset; // Asignar señal de reinicio debounced al LED 8

endmodule