module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Next state bit for S0:
    // S0 <= S0 and in==0, or S1 and in==0, or S2 and in==0, or S3 and in==0, or S4 and in==0,
    // or S7 and in==0, or S8 and in==0, or S9 and in==0
    wire next_S0 = 
          (state[0] & ~in)  // S0 --0--> S0
        | (state[1] & ~in)  // S1 --0--> S0
        | (state[2] & ~in)  // S2 --0--> S0
        | (state[3] & ~in)  // S3 --0--> S0
        | (state[4] & ~in)  // S4 --0--> S0
        | (state[7] & ~in)  // S7 --0--> S0
        | (state[8] & ~in)  // S8 --0--> S0
        | (state[9] & ~in); // S9 --0--> S0

    // Next state bit for S1:
    // S1 <= S0 and in==1, or S9 and in==1, or S8 and in==1
    wire next_S1 = 
          (state[0] &  in)  // S0 --1--> S1
        | (state[9] &  in)  // S9 --1--> S1
        | (state[8] &  in); // S8 --1--> S1

    // Next state bit for S2:
    // S2 <= S1 and in==1
    wire next_S2 = (state[1] & in); // S1 --1--> S2

    // Next state bit for S3:
    // S3 <= S2 and in==1
    wire next_S3 = (state[2] & in); // S2 --1--> S3

    // Next state bit for S4:
    // S4 <= S3 and in==1
    wire next_S4 = (state[3] & in); // S3 --1--> S4

    // Next state bit for S5:
    // S5 <= S4 and in==1
    wire next_S5 = (state[4] & in); // S4 --1--> S5

    // Next state bit for S6:
    // S6 <= S5 and in==1
    wire next_S6 = (state[5] & in); // S5 --1--> S6

    // Next state bit for S7:
    // S7 <= S6 and in==1, or S7 and in==1
    wire next_S7 = (state[6] & in) | (state[7] & in);

    // Next state bit for S8:
    // S8 <= S5 and in==0
    wire next_S8 = (state[5] & ~in);

    // Next state bit for S9:
    // S9 <= S6 and in==0
    wire next_S9 = (state[6] & ~in);

    assign next_state = {next_S9, next_S8, next_S7, next_S6, next_S5, next_S4, next_S3, next_S2, next_S1, next_S0};

    // Output logic:
    // out1 is 1 when S8 or S9 active
    assign out1 = state[8] | state[9];

    // out2 is 1 when S7 or S9 active
    assign out2 = state[7] | state[9];

endmodule