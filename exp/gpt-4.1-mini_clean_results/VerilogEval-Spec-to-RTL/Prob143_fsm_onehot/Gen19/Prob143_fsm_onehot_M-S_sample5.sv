module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // next_state[S0] is active if any current state transitions to S0 on input 'in'
    // According to the transitions:
    // S0 --0--> S0
    // S1 --0--> S0
    // S2 --0--> S0
    // S3 --0--> S0
    // S4 --0--> S0
    // S7 --0--> S0
    // S8 --0--> S0
    // S9 --0--> S0
    // Also, S7 --0--> S0 and S8 --0--> S0 and S9 --0--> S0 
    // So S0 next = any of these states active with in=0

    wire in0 = ~in;
    wire in1 = in;

    assign next_state[0] = (state[0] & in0) | 
                           (state[1] & in0) | 
                           (state[2] & in0) | 
                           (state[3] & in0) | 
                           (state[4] & in0) | 
                           (state[7] & in0) | 
                           (state[8] & in0) | 
                           (state[9] & in0);

    // next_state[S1]: from
    // S0 --1--> S1
    // S8 --1--> S1
    // S9 --1--> S1
    assign next_state[1] = (state[0] & in1) | (state[8] & in1) | (state[9] & in1);

    // next_state[S2]:
    // S1 --1--> S2
    assign next_state[2] = state[1] & in1;

    // next_state[S3]:
    // S2 --1--> S3
    assign next_state[3] = state[2] & in1;

    // next_state[S4]:
    // S3 --1--> S4
    assign next_state[4] = state[3] & in1;

    // next_state[S5]:
    // S4 --1--> S5
    assign next_state[5] = state[4] & in1;

    // next_state[S6]:
    // S5 --1--> S6
    assign next_state[6] = state[5] & in1;

    // next_state[S7]:
    // S6 --1--> S7
    // S7 --1--> S7
    assign next_state[7] = (state[6] & in1) | (state[7] & in1);

    // next_state[S8]:
    // S5 --0--> S8
    assign next_state[8] = state[5] & in0;

    // next_state[S9]:
    // S6 --0--> S9
    assign next_state[9] = state[6] & in0;

    // Outputs:
    // out1 = 1 if S8 or S9 active
    // out2 = 1 if S7 or S9 active

    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule