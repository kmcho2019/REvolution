module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Combined next_state calculation using bit patterns:
    // [0] = ~in & (A or C)
    // [1] = in & (A or B or D)
    // [2] = ~in & (B or D)
    // [3] = in & C
    assign next_state = {
        in & state[2],                      // next_state[3] (D)
        ~in & (state[1] | state[3]),        // next_state[2] (C)
        in & (state[0] | state[1] | state[3]), // next_state[1] (B)
        ~in & (state[0] | state[2])         // next_state[0] (A)
    };

    // Output remains high only in state D (MSB of one-hot)
    assign out = state[3];

endmodule