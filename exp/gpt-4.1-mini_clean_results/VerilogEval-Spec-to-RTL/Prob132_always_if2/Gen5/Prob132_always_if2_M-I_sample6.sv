module TopModule (
    input  wire cpu_overheated,
    output wire shut_off_computer,
    input  wire arrived,
    input  wire gas_tank_empty,
    output wire keep_driving
);

    // shut_off_computer is asserted when cpu is overheated
    assign shut_off_computer = cpu_overheated;

    // keep_driving is true if not arrived and gas tank is not empty
    assign keep_driving = (~arrived) & (~gas_tank_empty);

endmodule