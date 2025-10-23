module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    wire shut_off_computer_w;
    wire keep_driving_w;

    // Combinational logic assignments
    assign shut_off_computer_w = cpu_overheated;
    assign keep_driving_w = (~arrived) & (~gas_tank_empty);

    // Register outputs with combinational sensitivity to avoid latches
    always @(*) begin
        shut_off_computer = shut_off_computer_w;
        keep_driving = keep_driving_w;
    end

endmodule