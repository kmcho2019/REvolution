module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Intermediate wires hold the combinational logic results
    wire shut_off_condition = cpu_overheated;
    wire keep_driving_condition = (~arrived) & (~gas_tank_empty);

    always @(*) begin
        // Default assignments to avoid inferred latches
        shut_off_computer = 1'b0;
        keep_driving      = 1'b0;

        // Assign outputs from intermediate combinational signals
        shut_off_computer = shut_off_condition;
        keep_driving      = keep_driving_condition;
    end

endmodule