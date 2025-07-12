module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    assign next_state[0] = (state[0] | state[2]) & ~in;      // A or C, input=0
    assign next_state[1] = in & (state[0] | state[1] | state[3]); // in=1 and (A or B or D)
    assign next_state[2] = (state[1] | state[3]) & ~in;      // B or D, input=0
    assign next_state[3] = state[2] & in;                    // C and input=1

    assign out = state[3];                                   // Output high only in D

endmodule