module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // next_state[0] = S0 next state if from any active state and input conditions:
    // From S0(0) with in=0 -> S0(0)
    // From S1(1) with in=0 -> S0(0)
    // From S2(2) with in=0 -> S0(0)
    // From S3(3) with in=0 -> S0(0)
    // From S4(4) with in=0 -> S0(0)
    // From S7(7) with in=0 -> S0(0)
    // From S8(8) with in=0 -> S0(0)
    // From S9(9) with in=0 -> S0(0)
    wire ns0 = (~in & (
                state[0] | state[1] | state[2] | state[3] | 
                state[4] | state[7] | state[8] | state[9]));

    // next_state[1] = S1 next state
    // From S0(0) with in=1 -> S1(1)
    // From S8(8) with in=1 -> S1(1)
    // From S9(9) with in=1 -> S1(1)
    wire ns1 = (in & state[0]) | (in & state[8]) | (in & state[9]);

    // next_state[2] = S2 next state
    // From S1(1) with in=1 -> S2(2)
    wire ns2 = in & state[1];

    // next_state[3] = S3 next state
    // From S2(2) with in=1 -> S3(3)
    wire ns3 = in & state[2];

    // next_state[4] = S4 next state
    // From S3(3) with in=1 -> S4(4)
    wire ns4 = in & state[3];

    // next_state[5] = S5 next state
    // From S4(4) with in=1 -> S5(5)
    wire ns5 = in & state[4];

    // next_state[6] = S6 next state
    // From S5(5) with in=1 -> S6(6)
    wire ns6 = in & state[5];

    // next_state[7] = S7 next state
    // From S5(5) with in=1 -> S6(6) no
    // From S6(6) with in=1 -> S7(7)
    // From S7(7) with in=1 -> S7(7)
    wire ns7 = (in & state[6]) | (in & state[7]);

    // next_state[8] = S8 next state
    // From S5(5) with in=0 -> S8(8)
    wire ns8 = (~in) & state[5];

    // next_state[9] = S9 next state
    // From S6(6) with in=0 -> S9(9)
    wire ns9 = (~in) & state[6];

    assign next_state = {ns9, ns8, ns7, ns6, ns5, ns4, ns3, ns2, ns1, ns0};

    // Outputs:
    // out1 is 1 in states S8 and S9
    assign out1 = state[8] | state[9];

    // out2 is 1 in state S7 only
    assign out2 = state[7];

endmodule