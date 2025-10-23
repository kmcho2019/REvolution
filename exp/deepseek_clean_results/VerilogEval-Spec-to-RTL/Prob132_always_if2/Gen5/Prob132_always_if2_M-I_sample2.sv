module TopModule (
    // CPU control signals
    input  cpu_overheated,
    output shut_off_computer,
    
    // Vehicle control signals
    input  arrived,
    input  gas_tank_empty,
    output keep_driving
);

    // Shut off computer immediately if CPU overheats
    assign shut_off_computer = cpu_overheated;
    
    // Keep driving only if not arrived AND gas tank is not empty
    assign keep_driving = ~arrived & ~gas_tank_empty;

endmodule