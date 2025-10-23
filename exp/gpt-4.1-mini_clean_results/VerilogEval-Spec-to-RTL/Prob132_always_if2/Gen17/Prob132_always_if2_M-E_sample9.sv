module TopModule (
    input      cpu_overheated,
    output     shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving
);

    // Shut off computer if CPU is overheated; otherwise, off.
    assign shut_off_computer = cpu_overheated ? 1'b1 : 1'b0;

    // Keep driving only if not arrived and gas tank not empty; otherwise, off.
    assign keep_driving = (~arrived) ? (~gas_tank_empty) : 1'b0;

endmodule