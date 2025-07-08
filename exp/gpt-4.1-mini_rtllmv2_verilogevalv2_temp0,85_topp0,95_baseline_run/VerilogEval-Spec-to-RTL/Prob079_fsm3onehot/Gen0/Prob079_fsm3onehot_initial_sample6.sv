module TopModule(
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // State encoding
    // A = 4'b0001, B = 4'b0010, C = 4'b0100, D = 4'b1000

    // Next state bits
    // next_state[0] = A next state
    // next_state[1] = B next state
    // next_state[2] = C next state
    // next_state[3] = D next state

    // By inspection:
    // A: in=0 -> A, in=1 -> B
    // next_state[0] (A) = state[A] & ~in + state[C] & ~in
    // next_state[1] (B) = state[A] & in + state[B] + state[D] & in
    // next_state[2] (C) = state[B] & ~in + state[D] & ~in
    // next_state[3] (D) = state[C] & in

    assign next_state[0] = (state[0] & ~in) | (state[2] & ~in); // A next
    assign next_state[1] = (state[0] & in) | (state[1]) | (state[3] & in); // B next
    assign next_state[2] = (state[1] & ~in) | (state[3] & ~in); // C next
    assign next_state[3] = (state[2] & in); // D next

    // Output is 1 only when state D is active
    assign out = state[3];

endmodule