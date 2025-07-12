module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);
    // One-hot encoding:
    // A = state[0]
    // B = state[1]
    // C = state[2]
    // D = state[3]

    // Next state logic by direct expressions from the state transition table:
    // next_state[0] (A): in=0 -> A or C, so (A & ~in) | (C & ~in) = ~in & (A | C)
    // next_state[1] (B): in=1 -> A or B or D, so (A & in) | (B & in) | (D & in) = in & (A | B | D)
    // next_state[2] (C): in=0 -> B or D, so (B & ~in) | (D & ~in) = ~in & (B | D)
    // next_state[3] (D): in=1 -> C only, so C & in

    assign next_state[0] = (~in & state[0]) | (~in & state[2]);
    assign next_state[1] = (in & state[0])  | (in & state[1]) | (in & state[3]);
    assign next_state[2] = (~in & state[1]) | (~in & state[3]);
    assign next_state[3] = in & state[2];

    // Output logic: output is '1' only in state D
    assign out = state[3];

endmodule