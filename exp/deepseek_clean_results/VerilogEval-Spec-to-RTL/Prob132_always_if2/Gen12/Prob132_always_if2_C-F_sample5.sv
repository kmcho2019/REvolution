module TopModule (
    input  cpu_overheated,
    output shut_off_computer,
    input  arrived,
    input  gas_tank_empty,
    output keep_driving
);

    // Simple unconditional assignment
    assign shut_off_computer = cpu_overheated;
    
    // Explicit case handling using ternary operator
    assign keep_driving = arrived ? 1'b0 : ~gas_tank_empty;

endmodule