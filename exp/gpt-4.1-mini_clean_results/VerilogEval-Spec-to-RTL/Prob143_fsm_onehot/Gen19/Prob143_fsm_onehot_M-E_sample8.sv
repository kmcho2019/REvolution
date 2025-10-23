module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Next state logic for each next_state bit (S0 to S9)
    // next_state[i] = OR over all current states j where there is a transition j --in--> i, with active state[j]

    // Transition mapping (from problem description):
    // S0(0): in=0->S0, in=1->S1
    // S1(1): in=0->S0, in=1->S2
    // S2(2): in=0->S0, in=1->S3
    // S3(3): in=0->S0, in=1->S4
    // S4(4): in=0->S0, in=1->S5
    // S5(5): in=0->S8, in=1->S6
    // S6(6): in=0->S9, in=1->S7
    // S7(7): in=0->S0, in=1->S7
    // S8(8): in=0->S0, in=1->S1
    // S9(9): in=0->S0, in=1->S1

    // next_state[0] (S0) active if:
    // - from S0 with in=0: state[0] & ~in
    // - from S1 with in=0: state[1] & ~in
    // - from S2 with in=0: state[2] & ~in
    // - from S3 with in=0: state[3] & ~in
    // - from S4 with in=0: state[4] & ~in
    // - from S7 with in=0: state[7] & ~in
    // - from S8 with in=0: state[8] & ~in
    // - from S9 with in=0: state[9] & ~in

    wire in_n = ~in;

    assign next_state[0] = (state[0] & in_n) |
                           (state[1] & in_n) |
                           (state[2] & in_n) |
                           (state[3] & in_n) |
                           (state[4] & in_n) |
                           (state[7] & in_n) |
                           (state[8] & in_n) |
                           (state[9] & in_n);

    // next_state[1] (S1) active if:
    // - from S0 with in=1: state[0] & in
    // - from S8 with in=1: state[8] & in
    // - from S9 with in=1: state[9] & in

    assign next_state[1] = (state[0] & in) |
                           (state[8] & in) |
                           (state[9] & in);

    // next_state[2] (S2) active if:
    // - from S1 with in=1: state[1] & in

    assign next_state[2] = (state[1] & in);

    // next_state[3] (S3) active if:
    // - from S2 with in=1: state[2] & in

    assign next_state[3] = (state[2] & in);

    // next_state[4] (S4) active if:
    // - from S3 with in=1: state[3] & in

    assign next_state[4] = (state[3] & in);

    // next_state[5] (S5) active if:
    // - from S4 with in=1: state[4] & in

    assign next_state[5] = (state[4] & in);

    // next_state[6] (S6) active if:
    // - from S5 with in=1: state[5] & in

    assign next_state[6] = (state[5] & in);

    // next_state[7] (S7) active if:
    // - from S6 with in=1: state[6] & in
    // - from S7 with in=1: state[7] & in

    assign next_state[7] = (state[6] & in) |
                           (state[7] & in);

    // next_state[8] (S8) active if:
    // - from S5 with in=0: state[5] & ~in

    assign next_state[8] = (state[5] & in_n);

    // next_state[9] (S9) active if:
    // - from S6 with in=0: state[6] & ~in

    assign next_state[9] = (state[6] & in_n);

    // Outputs:
    // From problem:
    // Outputs are zero except:
    // S7 outputs (0,1)
    // S8 outputs (1,0)
    // S9 outputs (1,1)

    // out1 = 1 if state 8 or 9 active
    assign out1 = state[8] | state[9];

    // out2 = 1 if state 7 or 9 active
    assign out2 = state[7] | state[9];

endmodule