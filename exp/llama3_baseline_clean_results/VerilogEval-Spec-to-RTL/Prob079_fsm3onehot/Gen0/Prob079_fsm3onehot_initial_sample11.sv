module TopModule(
    input in,
    input [3:0] state,  // One-hot encoding: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000
    output [3:0] next_state,
    output out
);

// Output logic based on the current state
assign out = state[3];  // Output is 1 only when in state D

// State transition logic
assign next_state[0] = (~in & state[0]) | (~in & state[2]) | (in & state[0]);  // Next state A
assign next_state[1] = (in & state[0]) | (in & state[1]) | (in & state[3]) | (~in & state[1]);  // Next state B
assign next_state[2] = (~in & state[1]) | (~in & state[3]);  // Next state C
assign next_state[3] = (in & state[2]);  // Next state D

endmodule