module AES_SBox (
    input wire CLOCK_50,          // Reloj de 50MHz
    input wire [9:0] SW,          // Interruptores de entrada
    output wire [9:0] LEDR,       // LEDs rojos
    input wire [1:0] KEY          // Botones pulsadores
);

    // Señales internas
    wire [7:0] data_in;          // Datos de entrada desde los interruptores
    wire [7:0] sbox_out;         // Salida de la S-box
    wire [7:0] control_out;      // Salida del módulo de control
    wire [7:0] led_data;         // Datos a mostrar en los LEDs
    wire encrypt_mode;           // Modo de encriptación/desencriptación
    wire raw_reset;              // Señal de reinicio sin procesar desde el botón
    wire debounced_reset;        // Señal de reinicio con rebote eliminado

    // Señales de entrada
    assign data_in = SW[7:0];
    assign encrypt_mode = SW[9];
    assign raw_reset = ~KEY[0];  // Botón activo en bajo

    // Instancia del Anti-rebote
    debouncer reset_debounce (
        .clk_50MHz(CLOCK_50),
        .btn_in(raw_reset),
        .btn_out(debounced_reset)
    );

    // Instancia de la S-box
    sbox_lookup sbox_inst (
        .encrypt(encrypt_mode),
        .address(data_in),
        .data_out(sbox_out)
    );

    // Instancia del módulo de control
    control control_inst (
        .clk(CLOCK_50),
        .reset(debounced_reset),
        .encrypt(encrypt_mode),
        .data_in(sbox_out),     // Entrada desde la S-box
        .data_out(control_out)
    );

    // Instancia de los LEDs
    led_display led_display_inst (
        .data(control_out),
        .leds(led_data)
    );

    // Salidas
    assign LEDR[7:0] = led_data;
    assign LEDR[9] = encrypt_mode;
    assign LEDR[8] = debounced_reset;

endmodule