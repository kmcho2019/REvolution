module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Split into 32 groups of 8 bits (last group has 7 bits)
    wire [7:0] partial_counts [0:31];
    
    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : COUNT_8BIT
            assign partial_counts[i] = in[i*8+7] + in[i*8+6] + in[i*8+5] + in[i*8+4] +
                                      in[i*8+3] + in[i*8+2] + in[i*8+1] + in[i*8];
        end
        // Handle last 7-bit group
        assign partial_counts[31] = in[254] + in[253] + in[252] + in[251] +
                                   in[250] + in[249] + in[248];
    endgenerate

    // Sum all partial counts
    assign out = partial_counts[0]  + partial_counts[1]  + partial_counts[2]  + partial_counts[3]  +
                 partial_counts[4]  + partial_counts[5]  + partial_counts[6]  + partial_counts[7]  +
                 partial_counts[8]  + partial_counts[9]  + partial_counts[10] + partial_counts[11] +
                 partial_counts[12] + partial_counts[13] + partial_counts[14] + partial_counts[15] +
                 partial_counts[16] + partial_counts[17] + partial_counts[18] + partial_counts[19] +
                 partial_counts[20] + partial_counts[21] + partial_counts[22] + partial_counts[23] +
                 partial_counts[24] + partial_counts[25] + partial_counts[26] + partial_counts[27] +
                 partial_counts[28] + partial_counts[29] + partial_counts[30] + partial_counts[31];

endmodule