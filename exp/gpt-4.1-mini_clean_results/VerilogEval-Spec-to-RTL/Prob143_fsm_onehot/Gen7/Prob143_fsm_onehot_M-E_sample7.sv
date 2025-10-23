module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Compute signals for input high and low
    wire in0 = ~in;
    wire in1 =  in;

    // next_state[0] is the OR of all transitions to S0 on input 0 from states S0..S9 that transition to S0 on input=0
    // According to FSM:
    // S0(0) --0--> S0 (state[0] & in0)
    // S1(1) --0--> S0 (state[1] & in0)
    // S2(2) --0--> S0 (state[2] & in0)
    // S3(3) --0--> S0 (state[3] & in0)
    // S4(4) --0--> S0 (state[4] & in0)
    // S7(7) --0--> S0 (state[7] & in0)
    // S8(8) --0--> S0 (state[8] & in0)
    // S9(9) --0--> S0 (state[9] & in0)
    wire next0_from_in0 = (state[0] | state[1] | state[2] | state[3] | state[4] | state[7] | state[8] | state[9]) & in0;

    // There are no transitions to S0 on input=1 in the FSM (all transitions on input=1 go to other states),
    // so next_state[0] = next0_from_in0 only
    assign next_state[0] = next0_from_in0;

    // next_state[1] (S1) is reached from:
    // S0 --1--> S1  => state[0] & in1
    // S8 --1--> S1  => state[8] & in1
    // S9 --1--> S1  => state[9] & in1
    assign next_state[1] = (state[0] | state[8] | state[9]) & in1;

    // next_state[2] (S2) from:
    // S1 --1--> S2
    assign next_state[2] = state[1] & in1;

    // next_state[3] (S3) from:
    // S2 --1--> S3
    assign next_state[3] = state[2] & in1;

    // next_state[4] (S4) from:
    // S3 --1--> S4
    assign next_state[4] = state[3] & in1;

    // next_state[5] (S5) from:
    // S4 --1--> S5
    assign next_state[5] = state[4] & in1;

    // next_state[6] (S6) from:
    // S5 --1--> S6
    assign next_state[6] = state[5] & in1;

    // next_state[7] (S7) from:
    // S6 --1--> S7
    // S7 --1--> S7 (self-loop on in=1)
    assign next_state[7] = (state[6] & in1) | (state[7] & in1);

    // next_state[8] (S8) from:
    // S5 --0--> S8
    assign next_state[8] = state[5] & in0;

    // next_state[9] (S9) from:
    // S6 --0--> S9
    assign next_state[9] = state[6] & in0;

    // Outputs
    // out1 = state[8] or state[9]
    assign out1 = state[8] | state[9];

    // out2 = state[7] or state[9]
    assign out2 = state[7] | state[9];

endmodule