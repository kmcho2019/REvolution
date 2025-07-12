module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // next_state[i] = OR of all conditions where FSM can transition into Si
    // For clarity, define input signals for 0 and 1
    wire in0 = ~in;
    wire in1 =  in;

    // Since the FSM is one-hot and multiple states can be active,
    // each next_state bit is asserted if any current state leads to that next state on input.

    // next_state[0] (S0): from S0 with in=0, S1 with in=0, S2 with in=0, S3 with in=0,
    // S4 with in=0, S7 with in=0, S8 with in=0, S9 with in=0
    wire ns0 = (state[0] & in0) |
               (state[1] & in0) |
               (state[2] & in0) |
               (state[3] & in0) |
               (state[4] & in0) |
               (state[7] & in0) |
               (state[8] & in0) |
               (state[9] & in0);

    // next_state[1] (S1): from S0 with in=1, S8 with in=1, S9 with in=1
    wire ns1 = (state[0] & in1) |
               (state[8] & in1) |
               (state[9] & in1);

    // next_state[2] (S2): from S1 with in=1
    wire ns2 = (state[1] & in1);

    // next_state[3] (S3): from S2 with in=1
    wire ns3 = (state[2] & in1);

    // next_state[4] (S4): from S3 with in=1
    wire ns4 = (state[3] & in1);

    // next_state[5] (S5): from S4 with in=1
    wire ns5 = (state[4] & in1);

    // next_state[6] (S6): from S5 with in=1
    wire ns6 = (state[5] & in1);

    // next_state[7] (S7): from S6 with in=1, S7 with in=1
    wire ns7 = (state[6] & in1) |
               (state[7] & in1);

    // next_state[8] (S8): from S5 with in=0
    wire ns8 = (state[5] & in0);

    // next_state[9] (S9): from S6 with in=0
    wire ns9 = (state[6] & in0);

    assign next_state = {ns9, ns8, ns7, ns6, ns5, ns4, ns3, ns2, ns1, ns0};

    // Outputs depend only on current states as specified:
    // out1 = 1 if S8 or S9 active
    // out2 = 1 if S7 or S9 active
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule