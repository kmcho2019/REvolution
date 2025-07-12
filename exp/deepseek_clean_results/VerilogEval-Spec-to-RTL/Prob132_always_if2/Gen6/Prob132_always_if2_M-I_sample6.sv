module TopModule (
    input      cpu_overheated,    // Signal when CPU temperature exceeds threshold
    output     shut_off_computer, // Control signal to power off computer
    input      arrived,           // Flag indicating destination reached
    input      gas_tank_empty,    // Signal when vehicle fuel is depleted
    output     keep_driving       // Control signal to continue driving
);

    // Immediate shutdown when CPU overheats
    assign shut_off_computer = cpu_overheated;
    
    // Continue driving only if not arrived AND tank isn't empty
    assign keep_driving = ~arrived & ~gas_tank_empty;

endmodule