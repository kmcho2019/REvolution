module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);
    // Decode current states for clarity
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];
    wire in_n = ~in;

    // Shared intermediate terms for next_state calculation
    wire from_A = A;
    wire from_B = B;
    wire from_C = C;
    wire from_D = D;

    // Next state logic optimized for minimal levels and shared terms
    // next_state[0] (A): from A or C when in=0
    assign next_state[0] = in_n & (from_A | from_C);

    // next_state[1] (B): from B when in=1 or from A or D when in=1
    assign next_state[1] = in & (from_A | from_B | from_D);

    // next_state[2] (C): from B or D when in=0
    assign next_state[2] = in_n & (from_B | from_D);

    // next_state[3] (D): from C when in=1
    assign next_state[3] = in & from_C;

    // Output logic (Moore): output is high only in state D
    assign out = D;

endmodule