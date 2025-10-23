module TopModule (
    input      cpu_overheated,
    output     shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving
);

    // Safety feature: Shut down immediately on overheating
    assign shut_off_computer = cpu_overheated;

    // Driving logic: Continue only if not arrived AND tank has gas
    assign keep_driving = ~arrived & ~gas_tank_empty;

endmodule