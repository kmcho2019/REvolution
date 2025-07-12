module TopModule (
    input  cpu_overheated,
    output shut_off_computer,
    input  arrived,
    input  gas_tank_empty,
    output keep_driving
);

    // shut_off_computer is asserted when CPU is overheated
    assign shut_off_computer = cpu_overheated;

    // keep_driving is asserted when NOT arrived and gas tank is NOT empty
    assign keep_driving = (~arrived) & (~gas_tank_empty);

endmodule