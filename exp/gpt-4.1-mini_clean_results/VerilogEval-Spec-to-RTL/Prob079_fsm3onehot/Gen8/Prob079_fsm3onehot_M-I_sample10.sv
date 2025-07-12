module TopModule(
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);
    // State encoding (one-hot):
    // A = 4'b0001 (state[0])
    // B = 4'b0010 (state[1])
    // C = 4'b0100 (state[2])
    // D = 4'b1000 (state[3])

    wire common_b_states = state[0] | state[1] | state[3];

    // next_state[0] = next state A
    // A from A(in=0) or C(in=0)
    assign next_state[0] = (state[0] | state[2]) & ~in;

    // next_state[1] = next state B
    // B from A(in=1), B(in=1), or D(in=1)
    assign next_state[1] = in & common_b_states;

    // next_state[2] = next state C
    // C from B(in=0) or D(in=0)
    assign next_state[2] = (state[1] | state[3]) & ~in;

    // next_state[3] = next state D
    // D from C(in=1)
    assign next_state[3] = state[2] & in;

    // Output is 1 only in state D
    assign out = state[3];

endmodule