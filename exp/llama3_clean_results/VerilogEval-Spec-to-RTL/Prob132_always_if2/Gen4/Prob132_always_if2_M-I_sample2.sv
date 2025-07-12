module TopModule (
    input      cpu_overheated,
    output     shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving
);

    // Direct assignment for shut_off_computer to simplify the logic
    assign shut_off_computer = cpu_overheated;
    
    // Conditional assignment for keep_driving to handle the arrived condition
    assign keep_driving = arrived ? 1'b0 : ~gas_tank_empty;

endmodule