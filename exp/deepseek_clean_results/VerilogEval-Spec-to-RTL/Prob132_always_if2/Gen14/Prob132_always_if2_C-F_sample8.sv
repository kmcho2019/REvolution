module TopModule (
    // CPU monitoring signals
    input      cpu_overheated,
    output     shut_off_computer,
    
    // Vehicle control signals
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving
);

    // Constants for clarity
    localparam ON  = 1'b1;
    localparam OFF = 1'b0;

    // Safety feature: shutdown when CPU overheats
    assign shut_off_computer = cpu_overheated ? ON : OFF;
    
    // Driving logic: continue only if not arrived AND has fuel
    assign keep_driving = ~(arrived | gas_tank_empty);

endmodule