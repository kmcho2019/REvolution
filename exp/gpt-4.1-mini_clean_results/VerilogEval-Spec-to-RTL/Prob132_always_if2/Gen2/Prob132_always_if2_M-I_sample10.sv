module TopModule (
    input  cpu_overheated,
    output shut_off_computer,
    input  arrived,
    input  gas_tank_empty,
    output keep_driving
);

    // Continuous assignment for shut_off_computer
    assign shut_off_computer = cpu_overheated;

    // Continuous assignment for keep_driving
    assign keep_driving = (~arrived) & (~gas_tank_empty);

endmodule