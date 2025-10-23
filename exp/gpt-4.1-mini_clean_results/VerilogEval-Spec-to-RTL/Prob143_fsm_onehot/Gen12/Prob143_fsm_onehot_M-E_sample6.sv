module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Define intermediate wires for clarity
    wire in0 = ~in;
    wire in1 = in;

    // Next state logic: each bit is the OR of all transitions into that state
    // For example, next_state[0] is set if any active current state transitions to S0
    
    assign next_state[0] = 
        // S0 transitions on 0 from S0, S1, S2, S3, S4, S7(out2=0), S8(out1=1), S9(out1=1,out2=1)
        (state[0] & in0) | // S0 --0--> S0
        (state[1] & in0) | // S1 --0--> S0
        (state[2] & in0) | // S2 --0--> S0
        (state[3] & in0) | // S3 --0--> S0
        (state[4] & in0) | // S4 --0--> S0
        (state[7] & in0) | // S7 --0--> S0
        (state[8] & in0) | // S8 --0--> S0
        (state[9] & in0);  // S9 --0--> S0

    assign next_state[1] =
        (state[0] & in1) | // S0 --1--> S1
        (state[8] & in1) | // S8 --1--> S1
        (state[9] & in1);  // S9 --1--> S1

    assign next_state[2] =
        (state[1] & in1);  // S1 --1--> S2

    assign next_state[3] =
        (state[2] & in1);  // S2 --1--> S3

    assign next_state[4] =
        (state[3] & in1);  // S3 --1--> S4

    assign next_state[5] =
        (state[4] & in1);  // S4 --1--> S5

    assign next_state[6] =
        (state[5] & in1);  // S5 --1--> S6

    assign next_state[7] =
        (state[6] & in1) | // S6 --1--> S7
        (state[7] & in1);  // S7 --1--> S7 (loop)

    assign next_state[8] =
        (state[5] & in0);  // S5 --0--> S8

    assign next_state[9] =
        (state[6] & in0);  // S6 --0--> S9


    // Output logic
    // out1 = 1 if S8 or S9 active (states 8 or 9)
    assign out1 = state[8] | state[9];

    // out2 = 1 if S7 or S9 active (states 7 or 9)
    assign out2 = state[7] | state[9];

endmodule