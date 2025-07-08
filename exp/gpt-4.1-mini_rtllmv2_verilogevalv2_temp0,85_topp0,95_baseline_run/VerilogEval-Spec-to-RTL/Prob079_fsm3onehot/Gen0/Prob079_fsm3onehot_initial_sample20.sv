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

    // Next state logic for each one-hot bit
    // From the table:
    // A: in=0 -> A, in=1 -> B
    // B: in=0 -> C, in=1 -> B
    // C: in=0 -> A, in=1 -> D
    // D: in=0 -> C, in=1 -> B

    assign next_state[0] = (A & ~in) | (C & ~in);             // Next A: from A(0), C(0)
    assign next_state[1] = (A &  in) | (B &  in) | (D &  in); // Next B: from A(1), B(1), D(1)
    assign next_state[2] = (B & ~in) | (D & ~in);             // Next C: from B(0), D(0)
    assign next_state[3] = (C &  in);                          // Next D: from C(1)

    // Output logic: output is 1 only in state D
    assign out = D;

endmodule