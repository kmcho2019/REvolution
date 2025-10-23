module TopModule (
    input      cpu_overheated,
    output     shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving
);

    // Direct assignment for simple overheating condition
    assign shut_off_computer = cpu_overheated;
    
    // Clear logical expression: keep driving only if not arrived AND tank not empty
    assign keep_driving = ~arrived & ~gas_tank_empty;

endmodule