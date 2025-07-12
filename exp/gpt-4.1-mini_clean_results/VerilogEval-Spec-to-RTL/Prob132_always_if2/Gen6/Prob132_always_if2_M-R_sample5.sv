module TopModule (
    input      cpu_overheated,
    output     shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving
);

    // shut_off_computer is asserted when cpu_overheated is true
    assign shut_off_computer = cpu_overheated;

    // keep_driving is true only when not arrived and gas tank is not empty
    assign keep_driving = (~arrived) & (~gas_tank_empty);

endmodule