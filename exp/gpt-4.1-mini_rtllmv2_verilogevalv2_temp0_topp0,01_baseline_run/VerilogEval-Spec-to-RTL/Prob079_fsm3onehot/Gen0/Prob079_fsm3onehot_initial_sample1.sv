module TopModule(
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // State encoding
    // A = 4'b0001
    // B = 4'b0010
    // C = 4'b0100
    // D = 4'b1000

    // next_state logic by inspection:
    // next_state[0] = A next state bit
    // next_state[1] = B next state bit
    // next_state[2] = C next state bit
    // next_state[3] = D next state bit

    // From table:
    // A(0001): in=0 -> A(0001), in=1 -> B(0010)
    // B(0010): in=0 -> C(0100), in=1 -> B(0010)
    // C(0100): in=0 -> A(0001), in=1 -> D(1000)
    // D(1000): in=0 -> C(0100), in=1 -> B(0010)

    assign next_state[0] = (state[0] & ~in) | (state[2] & ~in);
    assign next_state[1] = (state[0] & in)  | (state[1] & in) | (state[3] & in);
    assign next_state[2] = (state[1] & ~in) | (state[3] & ~in);
    assign next_state[3] = (state[2] & in);

    // Output is 1 only in state D
    assign out = state[3];

endmodule