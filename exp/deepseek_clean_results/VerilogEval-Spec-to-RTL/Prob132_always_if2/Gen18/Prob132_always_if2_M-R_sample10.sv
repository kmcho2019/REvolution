module TopModule (
    input      cpu_overheated,
    output     shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving
);

    // Thermal emergency handling - continuous assignment
    assign shut_off_computer = cpu_overheated ? 1'b1 : 1'b0;
    
    // Driving logic - continuous assignment
    assign keep_driving = (~arrived) ? ~gas_tank_empty : 1'b0;

endmodule