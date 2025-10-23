module TopModule (
    input      cpu_overheated,
    output     shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving
);

    // Shut off computer when overheated, otherwise keep it running
    assign shut_off_computer = cpu_overheated ? 1'b1 : 1'b0;
    
    // Keep driving if not arrived AND gas tank is not empty
    assign keep_driving = ~arrived ? ~gas_tank_empty : 1'b0;

endmodule