module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // next_state bits are combinational logic functions of state and input 'in'

    // next_state[0] = S0 next state active if:
    // From S0 on 0 input (state[0] & ~in)
    // OR from S1 on 0 input (state[1] & ~in)
    // OR from S2 on 0 input (state[2] & ~in)
    // OR from S3 on 0 input (state[3] & ~in)
    // OR from S4 on 0 input (state[4] & ~in)
    // OR from S7 on 0 input (state[7] & ~in)
    // OR from S8 on 0 input (state[8] & ~in)
    // OR from S9 on 0 input (state[9] & ~in)
    wire ns0 = (~in) & (
                  state[0] | state[1] | state[2] | state[3] | state[4] |
                  state[7] | state[8] | state[9]
                );

    // next_state[1] = S1 next state active if:
    // From S0 on 1 input (state[0] & in)
    // OR from S8 on 1 input (state[8] & in)
    // OR from S9 on 1 input (state[9] & in)
    wire ns1 = in & (state[0] | state[8] | state[9]);

    // next_state[2] = S2 next state active if:
    // From S1 on 1 input (state[1] & in)
    wire ns2 = state[1] & in;

    // next_state[3] = S3 next state active if:
    // From S2 on 1 input (state[2] & in)
    wire ns3 = state[2] & in;

    // next_state[4] = S4 next state active if:
    // From S3 on 1 input (state[3] & in)
    wire ns4 = state[3] & in;

    // next_state[5] = S5 next state active if:
    // From S4 on 1 input (state[4] & in)
    wire ns5 = state[4] & in;

    // next_state[6] = S6 next state active if:
    // From S5 on 1 input (state[5] & in)
    wire ns6 = state[5] & in;

    // next_state[7] = S7 next state active if:
    // From S6 on 1 input (state[6] & in)
    // OR from S7 on 1 input (state[7] & in)
    wire ns7 = (state[6] & in) | (state[7] & in);

    // next_state[8] = S8 next state active if:
    // From S5 on 0 input (state[5] & ~in)
    wire ns8 = state[5] & (~in);

    // next_state[9] = S9 next state active if:
    // From S6 on 0 input (state[6] & ~in)
    wire ns9 = state[6] & (~in);

    assign next_state = {ns9, ns8, ns7, ns6, ns5, ns4, ns3, ns2, ns1, ns0};

    // Outputs:
    // out1 = 1 when state S8 or S9 is active
    // out2 = 1 when state S7 or S9 is active
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule