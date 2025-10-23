module TopModule (
    // CPU safety signals
    input      cpu_overheated,
    output     shut_off_computer,
    
    // Vehicle control signals
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving
);

    // Immediate shutdown when CPU overheats
    assign shut_off_computer = cpu_overheated;
    
    // Driving logic: keep driving only if not arrived AND has fuel
    assign keep_driving = (~arrived) & (~gas_tank_empty);

endmodule