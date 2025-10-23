module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Intermediate partial next states from each current state
    wire [9:0] next_from_S0;
    wire [9:0] next_from_S1;
    wire [9:0] next_from_S2;
    wire [9:0] next_from_S3;
    wire [9:0] next_from_S4;
    wire [9:0] next_from_S5;
    wire [9:0] next_from_S6;
    wire [9:0] next_from_S7;
    wire [9:0] next_from_S8;
    wire [9:0] next_from_S9;

    // S0 transitions
    assign next_from_S0 = (state[0]) ?
        (in ? 10'b0000000010 /* S1 */ : 10'b0000000001 /* S0 */) : 10'b0;

    // S1 transitions
    assign next_from_S1 = (state[1]) ?
        (in ? 10'b0000000100 /* S2 */ : 10'b0000000001 /* S0 */) : 10'b0;

    // S2 transitions
    assign next_from_S2 = (state[2]) ?
        (in ? 10'b0000001000 /* S3 */ : 10'b0000000001 /* S0 */) : 10'b0;

    // S3 transitions
    assign next_from_S3 = (state[3]) ?
        (in ? 10'b0000010000 /* S4 */ : 10'b0000000001 /* S0 */) : 10'b0;

    // S4 transitions
    assign next_from_S4 = (state[4]) ?
        (in ? 10'b0000100000 /* S5 */ : 10'b0000000001 /* S0 */) : 10'b0;

    // S5 transitions
    assign next_from_S5 = (state[5]) ?
        (in ? 10'b0001000000 /* S6 */ : 10'b1000000000 /* S8 */) : 10'b0;

    // S6 transitions
    assign next_from_S6 = (state[6]) ?
        (in ? 10'b0010000000 /* S7 */ : 10'b0100000000 /* S9 */) : 10'b0;

    // S7 transitions
    assign next_from_S7 = (state[7]) ?
        (in ? 10'b0010000000 /* S7 */ : 10'b0000000001 /* S0 */) : 10'b0;

    // S8 transitions
    assign next_from_S8 = (state[8]) ?
        (in ? 10'b0000000010 /* S1 */ : 10'b0000000001 /* S0 */) : 10'b0;

    // S9 transitions
    assign next_from_S9 = (state[9]) ?
        (in ? 10'b0000000010 /* S1 */ : 10'b0000000001 /* S0 */) : 10'b0;

    // Combine all partial next states (OR of all)
    assign next_state = next_from_S0 | next_from_S1 | next_from_S2 | next_from_S3 | next_from_S4
                      | next_from_S5 | next_from_S6 | next_from_S7 | next_from_S8 | next_from_S9;

    // Outputs based on active current states
    // out1 = 1 for states S8 (8) and S9 (9)
    // out2 = 1 for states S7 (7) and S9 (9)
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule