module TopModule (
    input      cpu_overheated,
    output     shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving
);

    // Computer shutdown is purely based on overheating
    assign shut_off_computer = cpu_overheated;

    // Driving logic: only keep driving if not arrived AND tank not empty
    assign keep_driving = (~arrived) & (~gas_tank_empty);

endmodule