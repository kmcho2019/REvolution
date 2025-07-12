module TopModule (
    input      cpu_overheated,
    output     shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving
);

    // Continuous assignment for shut_off_computer: 1 if overheated, else 0
    assign shut_off_computer = cpu_overheated;

    // Continuous assignment for keep_driving:
    // If not arrived, drive ~gas_tank_empty; else 0
    assign keep_driving = (!arrived) ? ~gas_tank_empty : 1'b0;

endmodule