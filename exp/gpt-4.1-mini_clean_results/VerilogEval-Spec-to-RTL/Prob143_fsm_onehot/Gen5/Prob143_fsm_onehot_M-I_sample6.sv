module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Each next_state bit is the OR of all current states that transition into it,
    // gated by the input 'in' as required.

    // Using local parameters for clarity of state indices
    localparam S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4,
               S5 = 5, S6 = 6, S7 = 7, S8 = 8, S9 = 9;

    wire in0 = ~in;
    wire in1 = in;

    // next_state[0] = S0 next states when input=0 from all states
    assign next_state[S0] = 
          (state[S0] & in0)
        | (state[S1] & in0)
        | (state[S2] & in0)
        | (state[S3] & in0)
        | (state[S4] & in0)
        | (state[S7] & in0)
        | (state[S8] & in0)
        | (state[S9] & in0);

    // next_state[1] = S1 next states when input=1 or from S8,S9 with input=1
    assign next_state[S1] = 
          (state[S0] & in1)
        | (state[S8] & in1)
        | (state[S9] & in1);

    assign next_state[S2] = (state[S1] & in1);
    assign next_state[S3] = (state[S2] & in1);
    assign next_state[S4] = (state[S3] & in1);
    assign next_state[S5] = (state[S4] & in1);

    assign next_state[S6] = (state[S5] & in1);
    assign next_state[S7] = 
          (state[S6] & in1)
        | (state[S7] & in1);

    assign next_state[S8] = (state[S5] & in0);
    assign next_state[S9] = (state[S6] & in0);

    // Outputs: 
    // out1 = 1 when in states S8 or S9
    // out2 = 1 when in states S7 or S9
    assign out1 = state[S8] | state[S9];
    assign out2 = state[S7] | state[S9];

endmodule