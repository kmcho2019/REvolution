module TopModule (
    input  cpu_overheated,         // Indicates CPU overheating condition
    output shut_off_computer,      // Signal to power down computer
    input  arrived,                // Indicates destination arrival
    input  gas_tank_empty,         // Indicates empty fuel tank
    output keep_driving            // Signal to continue driving
);

    // Computer control: shut down immediately if overheated
    assign shut_off_computer = cpu_overheated;
    
    // Driving logic: continue driving if not arrived AND have fuel
    assign keep_driving = (~arrived) & (~gas_tank_empty);

endmodule