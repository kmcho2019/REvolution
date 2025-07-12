module TopModule (
    input      cpu_overheated,
    output     shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving
);

    // 2:1 mux for shut_off_computer
    assign shut_off_computer = cpu_overheated ? 1'b1 : 1'b0;

    // 2:1 mux for keep_driving
    assign keep_driving = ~arrived ? ~gas_tank_empty : 1'b0;

endmodule