module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Combinational logic for shut_off_computer with default assignment to avoid latches
    always @(*) begin
        shut_off_computer = 1'b0;            // default
        if (cpu_overheated)
            shut_off_computer = 1'b1;
    end

    // Combinational logic for keep_driving with default assignment and clear conditions
    always @(*) begin
        keep_driving = 1'b0;                 // default
        if (!arrived)
            keep_driving = ~gas_tank_empty;
    end

endmodule