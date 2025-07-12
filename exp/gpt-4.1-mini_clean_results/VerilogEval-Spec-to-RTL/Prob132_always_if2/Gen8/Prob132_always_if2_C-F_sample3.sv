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

        // Assign shut_off_computer using concise conditional
        shut_off_computer = cpu_overheated ? 1'b1 : 1'b0;

        // Assign keep_driving based on conditions using ternary operators
        keep_driving = (~arrived) ? (~gas_tank_empty ? 1'b1 : 1'b0) : 1'b0;
    end

endmodule