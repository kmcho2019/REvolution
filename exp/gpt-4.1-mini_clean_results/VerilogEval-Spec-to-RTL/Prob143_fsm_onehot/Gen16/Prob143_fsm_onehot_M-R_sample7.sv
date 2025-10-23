module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire not_in = ~in;

    // next_state[0]: transition to S0 from states on input=0
    assign next_state[0] = 
          (state[0] & not_in)  // S0 --0--> S0
        | (state[1] & not_in)  // S1 --0--> S0
        | (state[2] & not_in)  // S2 --0--> S0
        | (state[3] & not_in)  // S3 --0--> S0
        | (state[4] & not_in)  // S4 --0--> S0
        | (state[7] & not_in)  // S7 --0--> S0
        | (state[8] & not_in)  // S8 --0--> S0
        | (state[9] & not_in); // S9 --0--> S0

    assign next_state[1] = 
          (state[0] & in)   // S0 --1--> S1
        | (state[8] & in)   // S8 --1--> S1
        | (state[9] & in);  // S9 --1--> S1

    assign next_state[2] = (state[1] & in);   // S1 --1--> S2
    assign next_state[3] = (state[2] & in);   // S2 --1--> S3
    assign next_state[4] = (state[3] & in);   // S3 --1--> S4
    assign next_state[5] = (state[4] & in);   // S4 --1--> S5
    assign next_state[6] = (state[5] & in);   // S5 --1--> S6
    assign next_state[7] = ((state[6] | state[7]) & in); // S6 or S7 --1--> S7
    assign next_state[8] = (state[5] & not_in); // S5 --0--> S8
    assign next_state[9] = (state[6] & not_in); // S6 --0--> S9

    // Outputs as direct ORs of corresponding state bits
    assign out1 = state[8] | state[9];        // out1 active in S8, S9
    assign out2 = state[7] | state[9];        // out2 active in S7, S9

endmodule