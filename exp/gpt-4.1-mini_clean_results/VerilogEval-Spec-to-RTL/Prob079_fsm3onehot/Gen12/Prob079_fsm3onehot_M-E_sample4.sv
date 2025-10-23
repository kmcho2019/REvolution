module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // State bits for clarity
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Next state logic derived directly from the table:
    // next_state A:
    //   from A when in=0
    //   from C when in=0
    assign next_state[0] = (A & ~in) | (C & ~in);

    // next_state B:
    //   from A when in=1
    //   from B when in=1
    //   from D when in=1
    assign next_state[1] = (A & in) | (B & in) | (D & in);

    // next_state C:
    //   from B when in=0
    //   from D when in=0
    assign next_state[2] = (B & ~in) | (D & ~in);

    // next_state D:
    //   from C when in=1
    assign next_state[3] = C & in;

    // Output logic: Output=1 only in state D
    assign out = D;

endmodule