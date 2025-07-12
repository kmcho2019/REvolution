module TopModule (
    input      cpu_overheated,
    output     shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving
);

    // Output is high if the CPU is overheated
    assign shut_off_computer = cpu_overheated;

    // Continue driving only if not arrived and gas tank is not empty
    assign keep_driving = (~arrived) & (~gas_tank_empty);

endmodule