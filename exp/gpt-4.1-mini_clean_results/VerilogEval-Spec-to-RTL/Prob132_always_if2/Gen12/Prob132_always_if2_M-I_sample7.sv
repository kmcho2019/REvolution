module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Internal wires hold combinational logic
    wire shut_off_w = cpu_overheated;
    wire keep_driving_w = (~arrived) & (~gas_tank_empty);

    // Single always block assigns reg outputs from combinational wires
    always @(*) begin
        shut_off_computer = shut_off_w;
        keep_driving = keep_driving_w;
    end

endmodule