module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);
    // One-hot encoding:
    // A = 4'b0001
    // B = 4'b0010
    // C = 4'b0100
    // D = 4'b1000

    // Next state logic
    assign next_state[0] = (state[0] & ~in) | (state[2] & ~in);           // A next state (A=bit0)
    assign next_state[1] = (state[0] & in)  | (state[1] & in) | (state[3] & in); // B next state (bit1)
    assign next_state[2] = (state[1] & ~in) | (state[3] & ~in);           // C next state (bit2)
    assign next_state[3] = (state[2] & in);                               // D next state (bit3)

    // Output logic
    // Output is 1 only in state D, else 0
    assign out = state[3];

endmodule