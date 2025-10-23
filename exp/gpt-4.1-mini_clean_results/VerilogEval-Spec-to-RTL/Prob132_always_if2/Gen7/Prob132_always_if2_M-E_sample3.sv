module TopModule (
    input        cpu_overheated,
    output       shut_off_computer,
    input        arrived,
    input        gas_tank_empty,
    output       keep_driving
);

    // combinational logic directly expressed as continuous assignments
    assign shut_off_computer = cpu_overheated ? 1'b1 : 1'b0;
    assign keep_driving     = (~arrived) ? (~gas_tank_empty) : 1'b0;

endmodule