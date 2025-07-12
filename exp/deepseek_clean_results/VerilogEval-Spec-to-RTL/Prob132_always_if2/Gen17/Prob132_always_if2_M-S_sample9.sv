module TopModule (
    input  cpu_overheated,
    input  arrived,
    input  gas_tank_empty,
    output shut_off_computer,
    output keep_driving
);

    assign shut_off_computer = cpu_overheated;
    assign keep_driving = ~arrived & ~gas_tank_empty;

endmodule