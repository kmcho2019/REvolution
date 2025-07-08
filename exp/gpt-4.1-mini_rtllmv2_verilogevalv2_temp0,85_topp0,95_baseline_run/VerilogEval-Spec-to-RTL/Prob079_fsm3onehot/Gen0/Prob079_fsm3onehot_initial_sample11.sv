module TopModule(
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // State encoding for clarity
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Next state logic based on the table:
    // A(next) = (A & ~in) | (C & ~in)
    // B(next) = (A & in) | (B & in) | (D & in)
    // C(next) = (B & ~in) | (D & ~in)
    // D(next) = C & in

    assign next_state[0] = (A & ~in) | (C & ~in);          // A next
    assign next_state[1] = (A & in) | (B & in) | (D & in); // B next
    assign next_state[2] = (B & ~in) | (D & ~in);          // C next
    assign next_state[3] = C & in;                          // D next

    // Output logic (Moore): Output only depends on current state
    // Output = 1 only in state D
    assign out = D;

endmodule