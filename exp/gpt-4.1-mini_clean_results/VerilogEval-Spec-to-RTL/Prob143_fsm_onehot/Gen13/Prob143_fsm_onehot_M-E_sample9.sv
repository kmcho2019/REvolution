module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Define next state vectors for input=0 and input=1 cases
    wire [9:0] next_state_from_0;
    wire [9:0] next_state_from_1;

    // next_state_from_0: transitions when in == 0
    // From spec:
    // S0(0) --0--> S0(0)
    // S1(1) --0--> S0(0)
    // S2(2) --0--> S0(0)
    // S3(3) --0--> S0(0)
    // S4(4) --0--> S0(0)
    // S5(5) --0--> S8(8)
    // S6(6) --0--> S9(9)
    // S7(7) --0--> S0(0)
    // S8(8) --0--> S0(0)
    // S9(9) --0--> S0(0)
    assign next_state_from_0 = {
        /*9*/ state[6],      // S9 from S6 on 0
        /*8*/ state[5],      // S8 from S5 on 0
        /*7*/ 1'b0,          // no transitions to S7 on 0
        /*6*/ 1'b0,
        /*5*/ 1'b0,
        /*4*/ 1'b0,
        /*3*/ 1'b0,
        /*2*/ 1'b0,
        /*1*/ 1'b0,
        /*0*/ (state[0] | state[1] | state[2] | state[3] | state[4] | state[7] | state[8] | state[9])
    };

    // next_state_from_1: transitions when in == 1
    // From spec:
    // S0(0) --1--> S1(1)
    // S1(1) --1--> S2(2)
    // S2(2) --1--> S3(3)
    // S3(3) --1--> S4(4)
    // S4(4) --1--> S5(5)
    // S5(5) --1--> S6(6)
    // S6(6) --1--> S7(7)
    // S7(7) --1--> S7(7)
    // S8(8) --1--> S1(1)
    // S9(9) --1--> S1(1)
    assign next_state_from_1[0] = 1'b0;
    assign next_state_from_1[1] = state[0] | state[8] | state[9];
    assign next_state_from_1[2] = state[1];
    assign next_state_from_1[3] = state[2];
    assign next_state_from_1[4] = state[3];
    assign next_state_from_1[5] = state[4];
    assign next_state_from_1[6] = state[5];
    assign next_state_from_1[7] = state[6] | state[7];
    assign next_state_from_1[8] = 1'b0;
    assign next_state_from_1[9] = 1'b0;

    // Select next_state based on input 'in'
    assign next_state = in ? next_state_from_1 : next_state_from_0;

    // Outputs:
    // out1 = 1 if states S8 or S9 active
    // out2 = 1 if states S7 or S9 active
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule