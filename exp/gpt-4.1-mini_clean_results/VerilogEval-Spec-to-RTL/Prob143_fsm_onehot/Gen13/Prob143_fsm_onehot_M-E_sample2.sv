module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // next_state[0] (S0) transitions from:
    // S0 on input=0, S1 on input=0, S2 on input=0, S3 on input=0, S4 on input=0,
    // S7 on input=0, S8 on input=0, S9 on input=0
    wire ns0 = 
          (state[0] & ~in)
        | (state[1] & ~in)
        | (state[2] & ~in)
        | (state[3] & ~in)
        | (state[4] & ~in)
        | (state[7] & ~in)
        | (state[8] & ~in)
        | (state[9] & ~in);

    // next_state[1] (S1) transitions from:
    // S0 on input=1, S8 on input=1, S9 on input=1
    wire ns1 = 
          (state[0] & in)
        | (state[8] & in)
        | (state[9] & in);

    // next_state[2] (S2) from:
    // S1 on input=1
    wire ns2 = state[1] & in;

    // next_state[3] (S3) from:
    // S2 on input=1
    wire ns3 = state[2] & in;

    // next_state[4] (S4) from:
    // S3 on input=1
    wire ns4 = state[3] & in;

    // next_state[5] (S5) from:
    // S4 on input=1
    wire ns5 = state[4] & in;

    // next_state[6] (S6) from:
    // S5 on input=1
    wire ns6 = state[5] & in;

    // next_state[7] (S7) from:
    // S6 on input=1
    // S7 on input=1 (self loop)
    wire ns7 = (state[6] & in) | (state[7] & in);

    // next_state[8] (S8) from:
    // S5 on input=0
    wire ns8 = state[5] & ~in;

    // next_state[9] (S9) from:
    // S6 on input=0
    wire ns9 = state[6] & ~in;

    assign next_state = {ns9, ns8, ns7, ns6, ns5, ns4, ns3, ns2, ns1, ns0};

    // Outputs
    // out1 = 1 if S8 or S9 active
    assign out1 = state[8] | state[9];

    // out2 = 1 if S7 or S9 active
    assign out2 = state[7] | state[9];

endmodule