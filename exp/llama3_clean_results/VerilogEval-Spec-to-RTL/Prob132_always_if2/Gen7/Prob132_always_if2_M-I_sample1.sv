module TopModule (
    input      cpu_overheated,
    output     shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving
);

    // Directly assign shut_off_computer based on cpu_overheated
    assign shut_off_computer = cpu_overheated;

    // Use a single conditional expression for keep_driving
    assign keep_driving = ~arrived & ~gas_tank_empty;

endmodule