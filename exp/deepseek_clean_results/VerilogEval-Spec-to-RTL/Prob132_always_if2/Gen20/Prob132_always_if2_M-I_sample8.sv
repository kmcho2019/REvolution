module TopModule (
    input  cpu_overheated,
    output shut_off_computer,
    input  arrived,
    input  gas_tank_empty,
    output keep_driving
);

    // Direct connection - no logic needed
    assign shut_off_computer = cpu_overheated;

    // Optimized implementation using AOI21-like logic:
    // keep_driving = ~(arrived | gas_tank_empty)
    assign keep_driving = ~(arrived | gas_tank_empty);

endmodule