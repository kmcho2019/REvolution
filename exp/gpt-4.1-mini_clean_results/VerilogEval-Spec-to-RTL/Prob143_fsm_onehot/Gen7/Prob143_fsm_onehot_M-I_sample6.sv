module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // One-hot FSM transition logic expressed as direct combinational OR expressions per next state bit

    assign next_state[0] =
           (state[0] &&  (in == 1'b0))  // S0 --0--> S0
        || (state[1] &&  (in == 1'b0))  // S1 --0--> S0
        || (state[2] &&  (in == 1'b0))  // S2 --0--> S0
        || (state[3] &&  (in == 1'b0))  // S3 --0--> S0
        || (state[4] &&  (in == 1'b0))  // S4 --0--> S0
        || (state[7] &&  (in == 1'b0))  // S7 --0--> S0
        || (state[8] &&  (in == 1'b0))  // S8 --0--> S0
        || (state[9] &&  (in == 1'b0)); // S9 --0--> S0

    assign next_state[1] =
           (state[0] &&  (in == 1'b1))  // S0 --1--> S1
        || (state[8] &&  (in == 1'b1))  // S8 --1--> S1
        || (state[9] &&  (in == 1'b1)); // S9 --1--> S1

    assign next_state[2] =
           (state[1] &&  (in == 1'b1));  // S1 --1--> S2

    assign next_state[3] =
           (state[2] &&  (in == 1'b1));  // S2 --1--> S3

    assign next_state[4] =
           (state[3] &&  (in == 1'b1));  // S3 --1--> S4

    assign next_state[5] =
           (state[4] &&  (in == 1'b1));  // S4 --1--> S5

    assign next_state[6] =
           (state[5] &&  (in == 1'b1));  // S5 --1--> S6

    assign next_state[7] =
           (state[6] &&  (in == 1'b1))  // S6 --1--> S7
        || (state[7] &&  (in == 1'b1)); // S7 --1--> S7

    assign next_state[8] =
           (state[5] &&  (in == 1'b0));  // S5 --0--> S8

    assign next_state[9] =
           (state[6] &&  (in == 1'b0));  // S6 --0--> S9

    // Outputs from current states:
    // out1 = 1 if in S8 or S9 (state[8] or state[9])
    // out2 = 1 if in S7 or S9 (state[7] or state[9])

    localparam [9:0] mask_out1 = (1 << 8) | (1 << 9);
    localparam [9:0] mask_out2 = (1 << 7) | (1 << 9);

    assign out1 = |(state & mask_out1);
    assign out2 = |(state & mask_out2);

endmodule