module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);
    // State bits for readability
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];
    wire in_n = ~in;

    // Next state logic derived by direct sum-of-products then factored:
    // next_state[0] (A next): A&~in + C&~in  => in_n & (A | C)
    assign next_state[0] = in_n & (A | C);

    // next_state[1] (B next): A&in + B&in + D&in => in & (A | B | D)
    assign next_state[1] = in & (A | B | D);

    // next_state[2] (C next): B&~in + D&~in => in_n & (B | D)
    assign next_state[2] = in_n & (B | D);

    // next_state[3] (D next): C&in
    assign next_state[3] = C & in;

    // Output logic: asserted only in state D
    assign out = D;

endmodule