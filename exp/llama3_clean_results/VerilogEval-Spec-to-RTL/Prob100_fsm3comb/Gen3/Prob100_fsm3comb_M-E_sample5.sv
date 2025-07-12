module TopModule(
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

reg [1:0] next_state_LUT [7:0];
reg [0:0] out_LUT [7:0];

initial begin
    // Initialize the next state LUT
    next_state_LUT[0] = 2'b00; // A, in = 0
    next_state_LUT[1] = 2'b01; // A, in = 1
    next_state_LUT[2] = 2'b10; // B, in = 0
    next_state_LUT[3] = 2'b01; // B, in = 1
    next_state_LUT[4] = 2'b00; // C, in = 0
    next_state_LUT[5] = 2'b11; // C, in = 1
    next_state_LUT[6] = 2'b10; // D, in = 0
    next_state_LUT[7] = 2'b01; // D, in = 1

    // Initialize the output LUT
    out_LUT[0] = 1'b0; // A
    out_LUT[1] = 1'b0; // A
    out_LUT[2] = 1'b0; // B
    out_LUT[3] = 1'b0; // B
    out_LUT[4] = 1'b0; // C
    out_LUT[5] = 1'b0; // C
    out_LUT[6] = 1'b1; // D
    out_LUT[7] = 1'b1; // D
end

always @(*) begin
    // Use the concatenated state and input values to index into the LUTs
    next_state = next_state_LUT[{state, in}];
    out = out_LUT[{state, in}];
end

endmodule