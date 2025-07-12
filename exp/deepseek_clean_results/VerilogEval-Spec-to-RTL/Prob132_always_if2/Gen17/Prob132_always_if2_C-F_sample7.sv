module TopModule (
    input  cpu_overheated,
    output shut_off_computer,
    input  arrived,
    input  gas_tank_empty,
    output keep_driving
);

    // Direct assignment for simple condition
    assign shut_off_computer = cpu_overheated;
    
    // Power-optimized conditional evaluation
    assign keep_driving = ~arrived ? ~gas_tank_empty : 1'b0;

endmodule