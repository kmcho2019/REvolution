module TopModule (
    input  cpu_overheated,
    input  arrived,
    input  gas_tank_empty,
    output shut_off_computer,
    output keep_driving
);

    // shut_off_computer is high when cpu is overheated, else low
    assign shut_off_computer = cpu_overheated;

    // keep_driving is high when not arrived and gas tank is not empty; else low
    assign keep_driving = (~arrived) & (~gas_tank_empty);

endmodule