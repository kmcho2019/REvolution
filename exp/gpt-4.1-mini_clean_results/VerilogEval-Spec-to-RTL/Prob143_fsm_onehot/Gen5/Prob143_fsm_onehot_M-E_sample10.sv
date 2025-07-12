module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // next_state[0] corresponds to S0
    // next_state[i] corresponds to Si

    // Compute next_state bits by directly OR-ing all current state conditions leading to each next state
    // According to the FSM:
    // S0 transitions:
    //   from S0 on 0
    //   from S1 on 0
    //   from S2 on 0
    //   from S3 on 0
    //   from S4 on 0
    //   from S7 on 0
    //   from S8 on 0
    //   from S9 on 0

    // next_state[0] = (S0 & ~in) | (S1 & ~in) | (S2 & ~in) | (S3 & ~in) | (S4 & ~in) | (S7 & ~in) | (S8 & ~in) | (S9 & ~in);

    // next_state[1] (S1) = from S0 on 1, from S8 on 1, from S9 on 1
    // next_state[2] (S2) = from S1 on 1
    // next_state[3] (S3) = from S2 on 1
    // next_state[4] (S4) = from S3 on 1
    // next_state[5] (S5) = from S4 on 1
    // next_state[6] (S6) = from S5 on 1
    // next_state[7] (S7) = from S6 on 1, from S7 on 1
    // next_state[8] (S8) = from S5 on 0
    // next_state[9] (S9) = from S6 on 0

    // Compose expressions for all next_state bits as ORs of qualifying (state & input) terms

    wire s0 = state[0];
    wire s1 = state[1];
    wire s2 = state[2];
    wire s3 = state[3];
    wire s4 = state[4];
    wire s5 = state[5];
    wire s6 = state[6];
    wire s7 = state[7];
    wire s8 = state[8];
    wire s9 = state[9];

    assign next_state[0] =
           (~in) & (s0 | s1 | s2 | s3 | s4 | s7 | s8 | s9);
    
    assign next_state[1] =
           (in) & (s0 | s8 | s9);
    
    assign next_state[2] = (in) & s1;
    
    assign next_state[3] = (in) & s2;
    
    assign next_state[4] = (in) & s3;
    
    assign next_state[5] = (in) & s4;
    
    assign next_state[6] = (in) & s5;
    
    assign next_state[7] =
           (in & s6) | (in & s7);
    
    assign next_state[8] = (~in) & s5;
    
    assign next_state[9] = (~in) & s6;

    // Output logic:
    // out1 = 1 if state S8 or S9 is active
    // out2 = 1 if state S7 or S9 is active

    assign out1 = s8 | s9;
    assign out2 = s7 | s9;

endmodule