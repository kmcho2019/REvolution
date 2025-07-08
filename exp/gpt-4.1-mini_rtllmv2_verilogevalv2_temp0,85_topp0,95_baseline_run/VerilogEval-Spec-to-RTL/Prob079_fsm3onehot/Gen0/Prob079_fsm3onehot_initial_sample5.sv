module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // State encoding
    // A = 4'b0001 (state[0])
    // B = 4'b0010 (state[1])
    // C = 4'b0100 (state[2])
    // D = 4'b1000 (state[3])

    // Next state logic:
    // For in=0:
    // A -> A
    // B -> C
    // C -> A
    // D -> C
    // For in=1:
    // A -> B
    // B -> B
    // C -> D
    // D -> B

    assign next_state[0] = (state[0] & ~in) | (state[2] & ~in);      // A next: from A(in=0), from C(in=0)
    assign next_state[1] = (state[0] & in)  | (state[1] & in)  | (state[3] & in); // B next: from A(in=1), B(in=1), D(in=1)
    assign next_state[2] = (state[1] & ~in) | (state[3] & ~in);    // C next: from B(in=0), D(in=0)
    assign next_state[3] = (state[2] & in);                        // D next: from C(in=1)

    // Output logic: out=1 only in state D
    assign out = state[3];

endmodule