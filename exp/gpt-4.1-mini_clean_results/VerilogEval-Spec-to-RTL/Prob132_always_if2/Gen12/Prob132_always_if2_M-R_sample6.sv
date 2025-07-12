module TopModule (
    input  wire cpu_overheated,
    output wire shut_off_computer,
    input  wire arrived,
    input  wire gas_tank_empty,
    output wire keep_driving
);

    assign shut_off_computer = cpu_overheated;
    assign keep_driving = ~arrived & ~gas_tank_empty;

endmodule