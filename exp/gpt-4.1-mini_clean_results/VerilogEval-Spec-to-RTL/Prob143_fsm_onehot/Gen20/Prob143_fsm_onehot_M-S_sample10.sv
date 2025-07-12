module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire zero_in = ~in;
    wire one_in  =  in;

    // next_state logic: direct OR of terms without hierarchical grouping
    assign next_state[0] = (state[0] & zero_in) | (state[1] & zero_in) | (state[2] & zero_in) |
                           (state[3] & zero_in) | (state[4] & zero_in) | (state[7] & zero_in) |
                           (state[8] & zero_in) | (state[9] & zero_in);

    assign next_state[1] = ((state[0] | state[8] | state[9]) & one_in);
    assign next_state[2] = (state[1] & one_in);
    assign next_state[3] = (state[2] & one_in);
    assign next_state[4] = (state[3] & one_in);
    assign next_state[5] = (state[4] & one_in);
    assign next_state[6] = (state[5] & one_in);
    assign next_state[7] = ((state[6] | state[7]) & one_in);
    assign next_state[8] = (state[5] & zero_in);
    assign next_state[9] = (state[6] & zero_in);

    // output logic using bitmasking for compactness
    localparam [9:0] MASK_OUT1 = 10'b1100000000; // state[8] and state[9]
    localparam [9:0] MASK_OUT2 = 10'b0100000000 | 10'b1000000000 >> 2; // state[7] and state[9]
    // Actually better to write explicitly:
    // MASK_OUT2 = bits 7 and 9 -> positions: bit7 = 0x80, bit9 = 0x200 = 10'b1000000000
    // So MASK_OUT2 = 10'b1000000000 | 10'b0001000000 (bit7 is bit index 7)
    // Correcting mask values:

    assign out1 = |(state & MASK_OUT1);
    assign out2 = |(state & ((1 << 7) | (1 << 9)));

endmodule