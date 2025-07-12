module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // One-hot FSM transition logic expressed as direct combinational OR expressions per next state bit

    // Next state S0: transitions from many states on input 0
    assign next_state[0] =
           (state[0] &&  (in == 1'b0))  // S0 --0--> S0
        || (state[1] &&  (in == 1'b0))  // S1 --0--> S0
        || (state[2] &&  (in == 1'b0))  // S2 --0--> S0
        || (state[3] &&  (in == 1'b0))  // S3 --0--> S0
        || (state[4] &&  (in == 1'b0))  // S4 --0--> S0
        || (state[7] &&  (in == 1'b0))  // S7 --0--> S0
        || (state[8] &&  (in == 1'b0))  // S8 --0--> S0
        || (state[9] &&  (in == 1'b0)); // S9 --0--> S0

    // Next state S1: transitions from S0, S8, S9 on input 1
    assign next_state[1] =
           (state[0] &&  (in == 1'b1))  // S0 --1--> S1
        || (state[8] &&  (in == 1'b1))  // S8 --1--> S1
        || (state[9] &&  (in == 1'b1)); // S9 --1--> S1

    // Next state S2: from S1 on input 1
    assign next_state[2] = (state[1] && (in == 1'b1));  // S1 --1--> S2

    // Next state S3: from S2 on input 1
    assign next_state[3] = (state[2] && (in == 1'b1));  // S2 --1--> S3

    // Next state S4: from S3 on input 1
    assign next_state[4] = (state[3] && (in == 1'b1));  // S3 --1--> S4

    // Next state S5: from S4 on input 1
    assign next_state[5] = (state[4] && (in == 1'b1));  // S4 --1--> S5

    // Next state S6: from S5 on input 1
    assign next_state[6] = (state[5] && (in == 1'b1));  // S5 --1--> S6

    // Next state S7: from S6 or S7 on input 1
    assign next_state[7] =
           (state[6] && (in == 1'b1))  // S6 --1--> S7
        || (state[7] && (in == 1'b1)); // S7 --1--> S7

    // Next state S8: from S5 on input 0
    assign next_state[8] = (state[5] && (in == 1'b0));  // S5 --0--> S8

    // Next state S9: from S6 on input 0
    assign next_state[9] = (state[6] && (in == 1'b0));  // S6 --0--> S9


    // Outputs are functions of current states:

    // out1 = 1 if current state is S8 or S9
    // out2 = 1 if current state is S7 or S9

    localparam [9:0] MASK_OUT1 = (1 << 8) | (1 << 9);  // bits 8 and 9
    localparam [9:0] MASK_OUT2 = (1 << 7) | (1 << 9);  // bits 7 and 9

    assign out1 = |(state & MASK_OUT1);
    assign out2 = |(state & MASK_OUT2);

endmodule