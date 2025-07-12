module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Using ternary operators for compact and clear logic
    assign shut_off_computer = cpu_overheated ? 1'b1 : 1'b0;
    assign keep_driving = arrived ? 1'b0 : ~gas_tank_empty;

endmodule