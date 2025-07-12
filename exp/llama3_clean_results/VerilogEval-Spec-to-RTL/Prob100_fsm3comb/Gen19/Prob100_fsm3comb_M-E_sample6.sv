module TopModule(
    input  in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

// Define the lookup table for next state and output
reg [1:0] next_state_lut [3:0][1:0];
reg [0:0] out_lut [3:0][1:0];

initial begin
    // Initialize the LUT based on the state transition table
    next_state_lut[0][0] = 2'b00; out_lut[0][0] = 1'b0; // State A, in=0
    next_state_lut[0][1] = 2'b01; out_lut[0][1] = 1'b0; // State A, in=1
    next_state_lut[1][0] = 2'b10; out_lut[1][0] = 1'b0; // State B, in=0
    next_state_lut[1][1] = 2'b01; out_lut[1][1] = 1'b0; // State B, in=1
    next_state_lut[2][0] = 2'b00; out_lut[2][0] = 1'b0; // State C, in=0
    next_state_lut[2][1] = 2'b11; out_lut[2][1] = 1'b0; // State C, in=1
    next_state_lut[3][0] = 2'b10; out_lut[3][0] = 1'b1; // State D, in=0
    next_state_lut[3][1] = 2'b01; out_lut[3][1] = 1'b1; // State D, in=1
end

// Use the LUT to determine the next state and output
always @(*) begin
    next_state = next_state_lut[state][in];
    out = out_lut[state][in];
end

endmodule