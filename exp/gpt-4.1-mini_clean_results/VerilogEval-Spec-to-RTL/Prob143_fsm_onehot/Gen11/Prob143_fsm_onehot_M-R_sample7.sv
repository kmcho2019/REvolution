module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Next state when input = 0
    wire [9:0] next_state_0;
    assign next_state_0[0] =
           state[0]  // S0 --0--> S0
        || state[1]  // S1 --0--> S0
        || state[2]  // S2 --0--> S0
        || state[3]  // S3 --0--> S0
        || state[4]  // S4 --0--> S0
        || state[7]  // S7 --0--> S0
        || state[8]  // S8 --0--> S0
        || state[9]; // S9 --0--> S0

    assign next_state_0[1] = 1'b0;

    assign next_state_0[2] = 1'b0;

    assign next_state_0[3] = 1'b0;

    assign next_state_0[4] = 1'b0;

    assign next_state_0[5] = 1'b0;

    assign next_state_0[6] = 1'b0;

    assign next_state_0[7] = 1'b0;

    assign next_state_0[8] = state[5]; // S5 --0--> S8

    assign next_state_0[9] = state[6]; // S6 --0--> S9

    // Next state when input = 1
    wire [9:0] next_state_1;
    assign next_state_1[0] = 1'b0;

    assign next_state_1[1] =
           state[0]  // S0 --1--> S1
        || state[8]  // S8 --1--> S1
        || state[9]; // S9 --1--> S1

    assign next_state_1[2] = state[1]; // S1 --1--> S2

    assign next_state_1[3] = state[2]; // S2 --1--> S3

    assign next_state_1[4] = state[3]; // S3 --1--> S4

    assign next_state_1[5] = state[4]; // S4 --1--> S5

    assign next_state_1[6] = state[5]; // S5 --1--> S6

    assign next_state_1[7] =
           state[6]  // S6 --1--> S7
        || state[7]; // S7 --1--> S7

    assign next_state_1[8] = 1'b0;

    assign next_state_1[9] = 1'b0;

    // Select next_state based on input 'in'
    assign next_state = in ? next_state_1 : next_state_0;

    // Outputs: out1=1 for states S8 or S9; out2=1 for states S7 or S9
    assign out1 = |(state & (10'b0110000000)); // bits 8 and 9 set
    assign out2 = |(state & (10'b0100000010)); // bits 7 and 9 set

endmodule