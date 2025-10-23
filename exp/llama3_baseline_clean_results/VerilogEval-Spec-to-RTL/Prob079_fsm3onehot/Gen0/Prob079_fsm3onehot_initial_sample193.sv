module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Next State Logic
    assign next_state[0] = (~in & state[0]) | (~in & state[2]); // A or C to A
    assign next_state[1] = (in & state[0]) | (in & state[1]) | (in & state[3]); // A, B, or D to B
    assign next_state[2] = (~in & state[1]) | (~in & state[3]); // B or D to C
    assign next_state[3] = (in & state[2]); // C to D

    // Output Logic
    assign out = state[3]; // Output is high only for state D

endmodule