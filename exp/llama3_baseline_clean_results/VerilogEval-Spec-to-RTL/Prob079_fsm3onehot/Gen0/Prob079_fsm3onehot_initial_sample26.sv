module TopModule(
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

// State encoding
// A = 4'b0001
// B = 4'b0010
// C = 4'b0100
// D = 4'b1000

// Next state logic
assign next_state[0] = (state[0] & ~in) | (state[2] & ~in); // Next state A
assign next_state[1] = (state[0] & in) | (state[1] & in) | (state[3] & in); // Next state B
assign next_state[2] = (state[1] & ~in); // Next state C
assign next_state[3] = (state[2] & in); // Next state D

// Output logic
assign out = state[3]; // Output 1 when in state D, 0 otherwise

endmodule