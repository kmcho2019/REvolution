module TopModule(
    input  in,
    input  [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

// Define the lookup table for next states and outputs
reg [1:0] next_state_lut [4][2];
reg [0:0] out_lut [4][2];

// Initialize the lookup table
initial begin
    // State A (2'b00)
    next_state_lut[0][0] = 2'b00; // Next state A, in = 0
    next_state_lut[0][1] = 2'b01; // Next state B, in = 1
    out_lut[0][0] = 1'b0; // Output 0, in = 0
    out_lut[0][1] = 1'b0; // Output 0, in = 1

    // State B (2'b01)
    next_state_lut[1][0] = 2'b10; // Next state C, in = 0
    next_state_lut[1][1] = 2'b01; // Next state B, in = 1
    out_lut[1][0] = 1'b0; // Output 0, in = 0
    out_lut[1][1] = 1'b0; // Output 0, in = 1

    // State C (2'b10)
    next_state_lut[2][0] = 2'b00; // Next state A, in = 0
    next_state_lut[2][1] = 2'b11; // Next state D, in = 1
    out_lut[2][0] = 1'b0; // Output 0, in = 0
    out_lut[2][1] = 1'b0; // Output 0, in = 1

    // State D (2'b11)
    next_state_lut[3][0] = 2'b10; // Next state C, in = 0
    next_state_lut[3][1] = 2'b01; // Next state B, in = 1
    out_lut[3][0] = 1'b1; // Output 1, in = 0
    out_lut[3][1] = 1'b1; // Output 1, in = 1
end

// Use the lookup table to determine the next state and output
always @(*) begin
    next_state = next_state_lut[state][in];
    out = out_lut[state][in];
end

endmodule