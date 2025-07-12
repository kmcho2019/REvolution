module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        // Default assignments to avoid inferred latches
        shut_off_computer = 1'b0;
        keep_driving      = 1'b0;

        // Combinational logic assignments
        shut_off_computer = cpu_overheated;
        keep_driving      = ~arrived & ~gas_tank_empty;
    end

endmodule