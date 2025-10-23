module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // For each next_state bit, assign 1 if any current state transitions to it given input 'in'.
    // We reverse the transition direction: for each next state, find which current states could have 
    // transitioned to it based on input.
    
    // Transition table (current state --in--> next state):
    // S0(0) --0--> S0(0)
    // S0(0) --1--> S1(1)
    // S1(1) --0--> S0(0)
    // S1(1) --1--> S2(2)
    // S2(2) --0--> S0(0)
    // S2(2) --1--> S3(3)
    // S3(3) --0--> S0(0)
    // S3(3) --1--> S4(4)
    // S4(4) --0--> S0(0)
    // S4(4) --1--> S5(5)
    // S5(5) --0--> S8(8)
    // S5(5) --1--> S6(6)
    // S6(6) --0--> S9(9)
    // S6(6) --1--> S7(7)
    // S7(7) --0--> S0(0)
    // S7(7) --1--> S7(7)
    // S8(8) --0--> S0(0)
    // S8(8) --1--> S1(1)
    // S9(9) --0--> S0(0)
    // S9(9) --1--> S1(1)
    
    // next_state bits [0..9]:

    assign next_state[0] = 
          (state[0] & ~in)    // S0->S0 on 0
        | (state[1] & ~in)    // S1->S0 on 0
        | (state[2] & ~in)    // S2->S0 on 0
        | (state[3] & ~in)    // S3->S0 on 0
        | (state[4] & ~in)    // S4->S0 on 0
        | (state[7] & ~in)    // S7->S0 on 0
        | (state[8] & ~in)    // S8->S0 on 0
        | (state[9] & ~in);   // S9->S0 on 0

    assign next_state[1] =
          (state[0] & in)     // S0->S1 on 1
        | (state[8] & in)     // S8->S1 on 1
        | (state[9] & in);    // S9->S1 on 1

    assign next_state[2] =
          (state[1] & in);    // S1->S2 on 1

    assign next_state[3] =
          (state[2] & in);    // S2->S3 on 1

    assign next_state[4] =
          (state[3] & in);    // S3->S4 on 1

    assign next_state[5] =
          (state[4] & in);    // S4->S5 on 1

    assign next_state[6] =
          (state[5] & in);    // S5->S6 on 1

    assign next_state[7] =
          (state[6] & in)     // S6->S7 on 1
        | (state[7] & in);   // S7->S7 on 1

    assign next_state[8] =
          (state[5] & ~in);   // S5->S8 on 0

    assign next_state[9] =
          (state[6] & ~in);   // S6->S9 on 0

    // Outputs:
    // out1 = 1 if in S8 or S9
    // out2 = 1 if in S7 or S9

    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule