module TopModule (
    input  cpu_overheated,
    output shut_off_computer,
    input  arrived,
    input  gas_tank_empty,
    output keep_driving
);

    // Direct assignment for immediate CPU shutdown
    assign shut_off_computer = cpu_overheated;
    
    // Efficient driving logic with clear conditions
    assign keep_driving = ~arrived & ~gas_tank_empty;

endmodule