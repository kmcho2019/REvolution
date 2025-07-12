module TopModule (
    input      cpu_overheated,
    output     shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving
);

    // Directly assign shut_off_computer based on cpu_overheated
    assign shut_off_computer = cpu_overheated;

    // Keep driving if not arrived and the gas tank is not empty
    assign keep_driving = ~arrived & ~gas_tank_empty;

endmodule