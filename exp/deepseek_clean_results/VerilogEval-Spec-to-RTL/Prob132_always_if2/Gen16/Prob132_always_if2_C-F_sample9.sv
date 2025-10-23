module TopModule (
    input      cpu_overheated,
    output     shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving
);

    // Shut down computer immediately if overheated
    assign shut_off_computer = cpu_overheated;
    
    // Keep driving only if not arrived AND tank isn't empty
    assign keep_driving = ~arrived & ~gas_tank_empty;

endmodule