module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

    // Implementing next state logic
    assign next_state[0] = (~in & (state[0] | state[2])) | (in & state[1] & ~state[3]); // A
    assign next_state[1] = in & (state[0] | state[1] | state[3]); // B
    assign next_state[2] = ~in & (state[1]); // C
    assign next_state[3] = in & (state[2]); // D

    // Implementing output logic
    assign out = state[3]; // out is 1 only when in state D

endmodule