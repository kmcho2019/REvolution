module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Simplified next state logic
    assign next_state[0] = (~in & state[0]) | (~in & state[2]);  // A: from A or C when in=0
    assign next_state[1] = (in & state[0]) | (in & state[1]) | (in & state[3]);  // B: from A,B,D when in=1
    assign next_state[2] = (~in & state[1]) | (~in & state[3]);  // C: from B or D when in=0
    assign next_state[3] = in & state[2];                        // D: from C when in=1

    // Output remains optimal
    assign out = state[3];

endmodule