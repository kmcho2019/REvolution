module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // One-hot state decoding
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Invert input once for reuse
    wire in_n = ~in;

    // Moore FSM next state logic (one-hot encoded):
    // From the table:
    // A: next_state = A if in=0 else B
    // B: next_state = C if in=0 else B
    // C: next_state = A if in=0 else D
    // D: next_state = C if in=0 else B
    assign next_state[0] = (A | C) & in_n;          // Next state A
    assign next_state[1] = (A | B | D) & in;        // Next state B
    assign next_state[2] = (B | D) & in_n;          // Next state C
    assign next_state[3] = C & in;                   // Next state D

    // Moore output: 1 only in state D
    assign out = D;

endmodule