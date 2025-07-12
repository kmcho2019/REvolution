module TopModule (
    input  cpu_overheated,
    output shut_off_computer,
    input  arrived,
    input  gas_tank_empty,
    output keep_driving
);

    // shut_off_computer is high if CPU overheated
    assign shut_off_computer = cpu_overheated;

    // keep_driving is high if not arrived AND gas tank not empty
    assign keep_driving = (~arrived) & (~gas_tank_empty);

endmodule