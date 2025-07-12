module TopModule (
    input      cpu_overheated,
    output     shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving
);

    wire not_arrived = ~arrived;

    assign shut_off_computer = cpu_overheated;
    assign keep_driving = not_arrived & ~gas_tank_empty;

endmodule