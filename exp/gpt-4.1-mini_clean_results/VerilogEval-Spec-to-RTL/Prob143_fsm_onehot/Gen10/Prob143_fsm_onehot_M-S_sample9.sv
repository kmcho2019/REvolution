module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // next_state[i] is 1 if any current active state transitions to Si given input `in`

    assign next_state[0] =  // S0 next states on input 0 from multiple states
        (~in & (state[0] | state[1] | state[2] | state[3] | state[4] | state[7] | state[8] | state[9])) |
        (~in & state[5]) | (~in & state[6]);

    assign next_state[1] =
        (in & state[0]) | (in & state[8]) | (in & state[9]);

    assign next_state[2] = (in & state[1]);
    assign next_state[3] = (in & state[2]);
    assign next_state[4] = (in & state[3]);
    assign next_state[5] = (in & state[4]);
    assign next_state[6] = (in & state[5]);
    assign next_state[7] = (in & state[6]) | (in & state[7]);
    assign next_state[8] = (~in & state[5]);
    assign next_state[9] = (~in & state[6]);

    // Output assignments using state masks
    assign out1 = |(state & 10'b1100000000); // S8, S9
    assign out2 = |(state & ((1 << 7) | (1 << 9))); // S7, S9

endmodule