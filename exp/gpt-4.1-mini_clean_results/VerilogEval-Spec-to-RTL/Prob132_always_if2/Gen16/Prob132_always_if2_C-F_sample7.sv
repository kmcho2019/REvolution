module TopModule (
    input      cpu_overheated,
    output     shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving
);

    // Output high when CPU is overheated, triggers computer shutdown
    assign shut_off_computer = cpu_overheated;

    // Continue driving only if not yet arrived and gas tank is not empty
    assign keep_driving = (~arrived) & (~gas_tank_empty);

endmodule