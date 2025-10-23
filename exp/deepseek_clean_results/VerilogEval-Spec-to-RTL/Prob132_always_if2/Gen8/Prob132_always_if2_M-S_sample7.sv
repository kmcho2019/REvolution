module TopModule (
    input  cpu_overheated,
    output shut_off_computer,
    input  arrived,
    input  gas_tank_empty,
    output keep_driving
);

    assign shut_off_computer = cpu_overheated ? 1 : 0;
    assign keep_driving = (!arrived && !gas_tank_empty) ? 1 : 0;

endmodule