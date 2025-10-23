module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Combined next state and output LUT
    // Format: {next_state[2:0], z}
    reg [3:0] lut [0:9];  // 5 states * 2 inputs = 10 entries

    // Initialize LUT
    integer i;
    initial begin
        // Address format: {y, x}
        // x=0 cases
        lut[{3'b000, 1'b0}] = {3'b000, 1'b0};
        lut[{3'b001, 1'b0}] = {3'b001, 1'b0};
        lut[{3'b010, 1'b0}] = {3'b010, 1'b0};
        lut[{3'b011, 1'b0}] = {3'b001, 1'b1};
        lut[{3'b100, 1'b0}] = {3'b011, 1'b1};
        // x=1 cases
        lut[{3'b000, 1'b1}] = {3'b001, 1'b0};
        lut[{3'b001, 1'b1}] = {3'b100, 1'b0};
        lut[{3'b010, 1'b1}] = {3'b001, 1'b0};
        lut[{3'b011, 1'b1}] = {3'b010, 1'b1};
        lut[{3'b100, 1'b1}] = {3'b100, 1'b1};
        // Default cases (should never occur)
        for (i = 5; i < 8; i = i + 1) begin
            lut[{i[2:0], 1'b0}] = {3'b000, 1'b0};
            lut[{i[2:0], 1'b1}] = {3'b000, 1'b0};
        end
    end

    // Look up next state and output
    wire [3:0] lut_out = lut[{y, x}];
    wire [2:0] Y = lut_out[3:1];
    assign z = lut_out[0];
    assign Y0 = Y[0];

endmodule