module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// Next state logic for A (4'b0001)
assign next_state[0] = (~in & state[0]) | (in & state[2]); // A or C with in=1

// Next state logic for B (4'b0010)
assign next_state[1] = (in & state[0]) | (~in & state[1]) | (in & state[3]); // B or A with in=1 or D with in=1

// Next state logic for C (4'b0100)
assign next_state[2] = (~in & state[1]) | (~in & state[3]); // C or D with in=0

// Next state logic for D (4'b1000)
assign next_state[3] = (in & state[2]); // C with in=1

// Output logic
assign out = state[3]; // Output is 1 only when in state D

endmodule