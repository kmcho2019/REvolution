module TopModule (
    // CPU monitoring signals
    input      cpu_overheated,
    output     shut_off_computer,
    
    // Vehicle control signals
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving
);

    // Safety feature: immediately shut down if CPU overheats
    assign shut_off_computer = cpu_overheated;
    
    // Driving logic: continue only if not arrived AND has fuel
    assign keep_driving = ~arrived & ~gas_tank_empty;

endmodule