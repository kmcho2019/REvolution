module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Calculate the next state
    assign next_state[0] = (~in & (state[0] | state[2]));  // Next state is A
    assign next_state[1] = (in & state[0]) | (in & state[1]) | (in & state[3]) | (~in & state[1]);  // Next state is B
    assign next_state[2] = (~in & state[1]) | (~in & state[3]);  // Next state is C
    assign next_state[3] = (in & state[2]);  // Next state is D

    // Calculate the output
    assign out = state[3];  // Output is 1 if current state is D

endmodule