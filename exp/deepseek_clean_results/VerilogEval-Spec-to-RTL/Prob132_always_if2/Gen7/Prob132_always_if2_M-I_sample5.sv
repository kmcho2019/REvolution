module TopModule (
    // System control signals
    input  cpu_overheated,       // Active-high CPU overheat indicator
    output shut_off_computer,    // Active-high shutdown command
    
    // Vehicle control signals
    input  arrived,              // Active-high arrival indicator
    input  gas_tank_full,        // Active-high fuel status (changed from empty)
    output keep_driving          // Active-high continue driving command
);

    // Shut down computer immediately if CPU overheats
    assign shut_off_computer = cpu_overheated;
    
    // Keep driving if not arrived AND we have gas
    assign keep_driving = ~arrived & gas_tank_full;

endmodule