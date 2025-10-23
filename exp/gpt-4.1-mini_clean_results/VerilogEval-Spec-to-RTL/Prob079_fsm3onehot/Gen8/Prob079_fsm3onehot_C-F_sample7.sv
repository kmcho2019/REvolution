module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // One-hot encoded current state bits for readability
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Invert input once for reuse
    wire in_n = ~in;

    // Precompute combined state signals to reduce OR gate fan-in
    wire state_0_2   = A | C;         // States A or C
    wire state_0_1_3 = A | B | D;     // States A, B, or D
    wire state_1_3   = B | D;         // States B or D

    // Next state combinational logic using factored terms:
    // next_state[0] = in=0 and (A or C)
    assign next_state[0] = in_n & state_0_2;

    // next_state[1] = in=1 and (A, B, or D)
    assign next_state[1] = in & state_0_1_3;

    // next_state[2] = in=0 and (B or D)
    assign next_state[2] = in_n & state_1_3;

    // next_state[3] = in=1 and C
    assign next_state[3] = in & C;

    // Output logic: Moore machine output depends only on state D
    assign out = D;

endmodule