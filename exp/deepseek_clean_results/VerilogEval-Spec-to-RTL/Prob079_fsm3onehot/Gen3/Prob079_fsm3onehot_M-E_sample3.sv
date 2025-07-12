module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Next state logic using direct bitwise computation
    assign next_state[0] = (~in & state[0]) | (~in & state[2]); // A stays or C->A
    assign next_state[1] = (in & state[0]) | (in & state[1]) | (in & state[3]); // A->B, B stays, D->B
    assign next_state[2] = (~in & state[1]) | (~in & state[3]); // B->C, D->C
    assign next_state[3] = (in & state[2]); // C->D

    // Output logic
    assign out = state[3]; // Output is 1 only in state D

endmodule