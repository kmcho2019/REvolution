module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

reg [3:0] next_state_reg;
assign next_state = next_state_reg;
reg out_reg;
assign out = out_reg;

// Define the lookup table (LUT) for next states and outputs
reg [3:0] lut_next_state [4][2];
reg [1:0] lut_out [4][2];

initial begin
    // Initialize the LUT with the next state and output values
    lut_next_state[0][0] = 4'b0001; // State A, in=0
    lut_next_state[0][1] = 4'b0010; // State A, in=1
    lut_next_state[1][0] = 4'b0100; // State B, in=0
    lut_next_state[1][1] = 4'b0010; // State B, in=1
    lut_next_state[2][0] = 4'b0001; // State C, in=0
    lut_next_state[2][1] = 4'b1000; // State C, in=1
    lut_next_state[3][0] = 4'b0100; // State D, in=0
    lut_next_state[3][1] = 4'b0010; // State D, in=1

    lut_out[0][0] = 1'b0; // State A, in=0
    lut_out[0][1] = 1'b0; // State A, in=1
    lut_out[1][0] = 1'b0; // State B, in=0
    lut_out[1][1] = 1'b0; // State B, in=1
    lut_out[2][0] = 1'b0; // State C, in=0
    lut_out[2][1] = 1'b0; // State C, in=1
    lut_out[3][0] = 1'b1; // State D, in=0
    lut_out[3][1] = 1'b1; // State D, in=1
end

always @(*) begin
    // Determine the current state index
    reg [1:0] state_index;
    if (state == 4'b0001) state_index = 0;
    else if (state == 4'b0010) state_index = 1;
    else if (state == 4'b0100) state_index = 2;
    else if (state == 4'b1000) state_index = 3;

    // Index into the LUT to determine the next state and output
    next_state_reg = lut_next_state[state_index][in];
    out_reg = lut_out[state_index][in];
end

endmodule