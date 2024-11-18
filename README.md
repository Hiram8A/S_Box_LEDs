# Documentación de la Implementación de AES S-Box en FPGA

## Estructura del Proyecto

```
AES_SBox/
├── src/
│   ├── AES_SBox.v         # Módulo Top Level.
│   ├── sbox_lookup.v      # Implementación de S-box.
│   ├── debouncer.v        # Antirrebote de botones.
│   └── led_display.v      # Buffer para la salida de los LEDs.
└── └── AES_SBox_tb.v      # Simulación TestBench
```

## Descripción de Módulos

### AES_SBox (Top Level / Nivel Superior)
- Driver principal del sistema
- Maneja el flujo de datos entre componentes
- Gestiona los modos de encriptación/desencriptación
- Entrada/Salida:
  - CLOCK_50: Reloj del sistema de 50MHz
  - SW[9:0]: Interruptores de entrada
  - LEDR[9:0]: LEDs de salida
  - KEY: Botón de reinicio

### sbox_lookup
- Implementa la sustitución S-box de AES
- Contiene tablas S-box directas e inversas
- Realiza la sustitución de bytes para encriptación/desencriptación

### Debouncer
- Maneja el antirrebote de la entrada de botones
- Previene activaciones involuntarias
- Tiempo de antirrebote configurable

## Descripción de Pines del Sistema

| Señal    | Pin   | Descripción                      |
|----------|-------|----------------------------------|
| CLOCK_50 | PIN50 | Reloj del sistema de 50MHz       |
| SW[9]    | PIN9  | Selección de modo                |
| SW[7:0]  | PIN1-8| Datos de entrada                 |
| LEDR[9:0]| LED0-9| LEDs de salida                   |
| KEY      | KEY0  | Botón del Reinicio del sistema   |


## Asignación de Pines del Sistema

| Señal    | Dirección | Ubicación | Banco I/O | Grupo VREF | Fitter Location  | Estándar I/O |
|----------|-----------|-----------|-----------|------------|------------------|--------------|
| CLOCK_50 | Input     | PIN_M9    | 3B        | B3B_N0     | PIN_M9           | 2.5 V        |
| KEY      | Input     | PIN_P22   | 5A        | B5A_N0     | PIN_P22          | 2.5 V        |
| LEDR[9]  | Output    | PIN_L1    | 2A        | B2A_N0     | PIN_L1           | 2.5 V        |
| LEDR[8]  | Output    | PIN_L2    | 2A        | B2A_N0     | PIN_L2           | 2.5 V        |
| LEDR[7]  | Output    | PIN_U1    | 2A        | B2A_N0     | PIN_U1           | 2.5 V        |
| LEDR[6]  | Output    | PIN_U2    | 2A        | B2A_N0     | PIN_U2           | 2.5 V        |
| LEDR[5]  | Output    | PIN_N1    | 2A        | B2A_N0     | PIN_N1           | 2.5 V        |
| LEDR[4]  | Output    | PIN_N2    | 2A        | B2A_N0     | PIN_N2           | 2.5 V        |
| LEDR[3]  | Output    | PIN_Y3    | 2A        | B2A_N0     | PIN_Y3           | 2.5 V        |
| LEDR[2]  | Output    | PIN_W2    | 2A        | B2A_N0     | PIN_W2           | 2.5 V        |
| LEDR[1]  | Output    | PIN_AA1   | 2A        | B2A_N0     | PIN_AA1          | 2.5 V        |
| LEDR[0]  | Output    | PIN_AA2   | 2A        | B2A_N0     | PIN_AA2          | 2.5 V        |
| SW[9]    | Input     | PIN_AB12  | 4A        | B4A_N0     | PIN_AB12         | 2.5 V        |
| SW[8]    | Input     | PIN_AB13  | 4A        | B4A_N0     | PIN_AB13         | 2.5 V        |
| SW[7]    | Input     | PIN_AA13  | 4A        | B4A_N0     | PIN_AA13         | 2.5 V        |
| SW[6]    | Input     | PIN_AA14  | 4A        | B4A_N0     | PIN_AA14         | 2.5 V        |
| SW[5]    | Input     | PIN_AB15  | 4A        | B4A_N0     | PIN_AB15         | 2.5 V        |
| SW[4]    | Input     | PIN_AA15  | 4A        | B4A_N0     | PIN_AA15         | 2.5 V        |
| SW[3]    | Input     | PIN_T12   | 4A        | B4A_N0     | PIN_T12          | 2.5 V        |
| SW[2]    | Input     | PIN_T13   | 4A        | B4A_N0     | PIN_T13          | 2.5 V        |
| SW[1]    | Input     | PIN_V13   | 4A        | B4A_N0     | PIN_V13          | 2.5 V        |
| SW[0]    | Input     | PIN_U13   | 4A        | B4A_N0     | PIN_U13          | 2.5 V        |



### Implementación de Lookup Tables 

#### S-box Directa (Forward S-box)
La S-box directa es una tabla de sustitución no lineal de 256 bytes que mapea cada byte de entrada a un valor de sustitución único. La tabla está organizada en una matriz 16x16 donde:
- Las filas representan el dígito hexadecimal más significativo (0-F)
- Las columnas representan el dígito hexadecimal menos significativo (0-F)
- Cada celda contiene el valor de sustitución en hexadecimal

Por ejemplo, para el valor de entrada 0x52, la tabla devuelve el valor 0x00.

### LUT S-box directa (Forward S-box)
```
     0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
0 | 63 7C 77 7B F2 6B 6F C5 30 01 67 2B FE D7 AB 76
1 | CA 82 C9 7D FA 59 47 F0 AD D4 A2 AF 9C A4 72 C0
2 | B7 FD 93 26 36 3F F7 CC 34 A5 E5 F1 71 D8 31 15
3 | 04 C7 23 C3 18 96 05 9A 07 12 80 E2 EB 27 B2 75
4 | 09 83 2C 1A 1B 6E 5A A0 52 3B D6 B3 29 E3 2F 84
5 | 53 D1 00 ED 20 FC B1 5B 6A CB BE 39 4A 4C 58 CF
6 | D0 EF AA FB 43 4D 33 85 45 F9 02 7F 50 3C 9F A8
7 | 51 A3 40 8F 92 9D 38 F5 BC B6 DA 21 10 FF F3 D2
8 | CD 0C 13 EC 5F 97 44 17 C4 A7 7E 3D 64 5D 19 73
9 | 60 81 4F DC 22 2A 90 88 46 EE B8 14 DE 5E 0B DB
A | E0 32 3A 0A 49 06 24 5C C2 D3 AC 62 91 95 E4 79
B | E7 C8 37 6D 8D D5 4E A9 6C 56 F4 EA 65 7A AE 08
C | BA 78 25 2E 1C A6 B4 C6 E8 DD 74 1F 4B BD 8B 8A
D | 70 3E B5 66 48 03 F6 0E 61 35 57 B9 86 C1 1D 9E
E | E1 F8 98 11 69 D9 8E 94 9B 1E 87 E9 CE 55 28 DF
F | 8C A1 89 0D BF E6 42 68 41 99 2D 0F B0 54 BB 16
```

#### S-box Inversa (Inverse S-box)
La S-box inversa realiza la operación opuesta a la S-box directa, permitiendo la desencriptación. La tabla está organizada de manera similar:
- Matriz 16x16 con índices hexadecimales
- Mapeo inverso que permite recuperar el valor original
- Se utiliza durante el proceso de desencriptación


### LUT S-box inversa (Inverse S-box)

```
     0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
0 | 52 09 6A D5 30 36 A5 38 BF 40 A3 9E 81 F3 D7 FB
1 | 7C E3 39 82 9B 2F FF 87 34 8E 43 44 C4 DE E9 CB
2 | 54 7B 94 32 A6 C2 23 3D EE 4C 95 0B 42 FA C3 4E
3 | 08 2E A1 66 28 D9 24 B2 76 5B A2 49 6D 8B D1 25
4 | 72 F8 F6 64 86 68 98 16 D4 A4 5C CC 5D 65 B6 92
5 | 6C 70 48 50 FD ED B9 DA 5E 15 46 57 A7 8D 9D 84
6 | 90 D8 AB 00 8C BC D3 0A F7 E4 58 05 B8 B3 45 06
7 | D0 2C 1E 8F CA 3F 0F 02 C1 AF BD 03 01 13 8A 6B
8 | 3A 91 11 41 4F 67 DC EA 97 F2 CF CE F0 B4 E6 73
9 | 96 AC 74 22 E7 AD 35 85 E2 F9 37 E8 1C 75 DF 6E
A | 47 F1 1A 71 1D 29 C5 89 6F B7 62 0E AA 18 BE 1B
B | FC 56 3E 4B C6 D2 79 20 9A DB C0 FE 78 CD 5A F4
C | 1F DD A8 33 88 07 C7 31 B1 12 10 59 27 80 EC 5F
D | 60 51 7F A9 19 B5 4A 0D 2D E5 7A 9F 93 C9 9C EF
E | A0 E0 3B 4D AE 2A F5 B0 C8 EB BB 3C 83 53 99 61
F | 17 2B 04 7E BA 77 D6 26 E1 69 14 63 55 21 0C 7D
```

Las tablas se implementan como arreglos de 256 elementos en el módulo `sbox_lookup.v`, permitiendo una sustitución eficiente en un solo ciclo de reloj.



## Guía de Operación

1. **Reiniciar Sistema**
   - Presione KEY (Reset) para inicializar el sistema
   - Todos los registros se limpian

2. **Modo de Encriptación**
   - Se selecciona el SW[9] = 1
   - Ingrese datos a través de SW[7:0]
   - Resultado mostrado en LEDR[7:0]

3. **Modo de Desencriptación**
   - Se selecciona el SW[9] = 0
   - Usa datos encriptados almacenados
   - Resultado mostrado en LEDR[7:0]

## Indicadores de Estado (LEDs)

- LEDR[9]: Indicador de modo (1=encriptar, 0=desencriptar)
- LEDR[8]: Estado de reinicio
- LEDR[7:0]: Salida de datos

## Detalles de Implementación

```verilog
// Parámetros del antirebote
parameter DEBOUNCE_MS = 10;     // Tiempo de antirrebote de 10ms
parameter CLK_FREQ_MHZ = 50;    // Reloj del sistema de 50MHz
```

## Procedimiento del TestBench

1. Verificación de reinicio del sistema
2. Prueba de operación de encriptación
3. Verificación de almacenamiento de datos
4. Prueba de operación de desencriptación
5. Validación de cambio de modos (Encriptación / Desencriptación)

## Diagrama RTL

Para más detalles sobre el diagrama RTL, consulte el siguiente enlace: [Diagrama RTL](RTL_Diagram.pdf).

## Referencias

- [Estándar AES (FIPS 197)](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.197.pdf)
- [Documentación de la placa FPGA](https://www.manualslib.com/manual/1493239/Terasic-De0-Cv.html#manual)
- [Software Quartus Prime](https://www.intel.com/content/www/us/en/support/programmable/support-resources/design-software/user-guides.html)
- [Rijndael Algorithm](https://cs.ru.nl/~joan/papers/JDA_VRI_Rijndael_2002.pdf)

---

## Flow Summary - AES S-Box Implementation

### Project Details
| Parameter | Value |
|-----------|-------|
| Project | AES-SBox |
| Entity Name | AES_SBox |
| Quartus Version | 23.1std.1 Build 993 |
| Build Date | 05/14/2024 SC Lite Edition |

### Device Information
| Parameter | Value |
|-----------|-------|
| Family | Cyclone V |
| Device | 5CEBA4F23C7 |
| Timing Models | Final |

### Resource Utilization
| Resource | Used | Available | Utilization |
|----------|------|-----------|-------------|
| ALMs | 108 | 18,480 | < 1% |
| Registers | 35 | - | - |
| Pins | 22 | 224 | 10% |
| Block Memory Bits | 0 | 3,153,920 | 0% |
| DSP Blocks | 0 | 66 | 0% |
| PLLs | 0 | 4 | 0% |
| DLLs | 0 | 4 | 0% |

### Additional Resources
| Resource | Used |
|----------|------|
| Virtual Pins | 0 |
| HSSI RX PCSs | 0 |
| HSSI PMA RX Deserializers | 0 |
| HSSI TX PCSs | 0 |
| HSSI PMA TX Serializers | 0 |

## Compilation Status

Status: Compilation Successful (Sun Nov 17 2024)
