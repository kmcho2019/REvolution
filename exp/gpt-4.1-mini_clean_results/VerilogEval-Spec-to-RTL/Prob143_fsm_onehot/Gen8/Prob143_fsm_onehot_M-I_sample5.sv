module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire in0 = ~in;
    wire in1 =  in;

    // For clarity, define each state's contribution to next_state bits
    
    // next_state[0] = sum of next states to S0:
    // S0,in=0; S1,in=0; S2,in=0; S3,in=0; S4,in=0; S7,in=0; S8,in=0; S9,in=0
    wire ns0 = (state[0] & in0) | 
               (state[1] & in0) | 
               (state[2] & in0) | 
               (state[3] & in0) | 
               (state[4] & in0) | 
               (state[7] & in0) | 
               (state[8] & in0) | 
               (state[9] & in0);

    // next_state[1] = S0,in=1 or S8,in=1 or S9,in=1
    wire ns1 = (state[0] & in1) |
               (state[8] & in1) |
               (state[9] & in1);

    // next_state[2] = S1,in=1
    wire ns2 = (state[1] & in1);

    // next_state[3] = S2,in=1
    wire ns3 = (state[2] & in1);

    // next_state[4] = S3,in=1
    wire ns4 = (state[3] & in1);

    // next_state[5] = S4,in=1
    wire ns5 = (state[4] & in1);

    // next_state[6] = S5,in=1
    wire ns6 = (state[5] & in1);

    // next_state[7] = S6,in=1 or S7,in=1
    wire ns7 = (state[6] & in1) |
               (state[7] & in1);

    // next_state[8] = S5,in=0
    wire ns8 = (state[5] & in0);

    // next_state[9] = S6,in=0
    wire ns9 = (state[6] & in0);

    assign next_state = {ns9, ns8, ns7, ns6, ns5, ns4, ns3, ns2, ns1, ns0};

    // Outputs depend on current state bits per spec:
    // out1 = state[8] or state[9]
    // out2 = state[7] or state[9]
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule