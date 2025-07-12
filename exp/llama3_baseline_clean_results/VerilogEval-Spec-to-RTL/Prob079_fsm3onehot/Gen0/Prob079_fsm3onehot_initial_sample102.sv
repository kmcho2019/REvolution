module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // State transition logic
    assign next_state[0] = (~in & (state[0] | state[2])) | (in & ~state[0] & ~state[1] & ~state[2] & state[3]);  // Next state is A
    assign next_state[1] = (state[0] & in) | (state[1] & (in | ~in)) | (state[3] & in);  // Next state is B
    assign next_state[2] = (~in & (state[1] | state[3]));  // Next state is C
    assign next_state[3] = (state[2] & in);  // Next state is D

    // Output logic
    assign out = state[3];  // Output is 1 when current state is D

endmodule