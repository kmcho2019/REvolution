module TopModule (
    // CPU control signals
    input  cpu_overheated,         // Indicates CPU overheating condition
    output shut_off_computer,      // Signal to power off computer
    
    // Vehicle control signals
    input  arrived,                // Indicates destination reached
    input  gas_tank_empty,         // Indicates empty fuel tank
    output keep_driving            // Signal to continue driving
);

    // Shut off computer immediately if CPU overheats
    assign shut_off_computer = cpu_overheated;
    
    // Keep driving only if not arrived AND gas tank is not empty
    assign keep_driving = ~arrived & ~gas_tank_empty;

endmodule