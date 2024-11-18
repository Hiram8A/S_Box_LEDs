# Documentación de la Implementación de AES S-Box en FPGA

## Estructura del Proyecto

```
AES_SBox/
├── src/
│   ├── AES_SBox.v         # Módulo de nivel superior
│   ├── sbox_lookup.v      # Implementación de S-box
│   ├── debouncer.v        # Antirrebote de botones
│   └── led_display.v      # Manejador de salida LED
└── test/
    └── AES_SBox_tb.v      # Simulación TestBench
```

## Descripción de Módulos

### AES_SBox (Nivel Superior)
- Controlador principal del sistema
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

## Asignación de Pines

| Señal    | Pin   | Descripción                |
|----------|-------|----------------------------|
| CLOCK_50 | PIN50 | Reloj del sistema de 50MHz |
| SW[9]    | PIN9  | Selección de modo          |
| SW[7:0]  | PIN1-8| Datos de entrada           |
| LEDR[9:0]| LED0-9| Pantalla de salida         |
| KEY      | KEY0  | Reinicio del sistema       |

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

## Indicadores de Estado

- LEDR[9]: Indicador de modo (1=encriptar, 0=desencriptar)
- LEDR[8]: Estado de reinicio
- LEDR[7:0]: Salida de datos

## Detalles de Implementación

```verilog
// Parámetros clave
parameter DEBOUNCE_MS = 10;     // Tiempo de antirrebote de 10ms
parameter CLK_FREQ_MHZ = 50;    // Reloj del sistema de 50MHz
```

## Procedimiento de Pruebas del TestBench

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
