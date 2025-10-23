module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // We'll process the input in 32 chunks: 31 chunks of 8 bits and 1 chunk of 7 bits
    wire [7:0] partial_counts [0:31];
    wire [7:0] total_count;

    // Count '1's in each 8-bit chunk (for first 31 chunks)
    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : count_8bit_chunks
            assign partial_counts[i] = 
                in[i*8 + 0] + in[i*8 + 1] + in[i*8 + 2] + in[i*8 + 3] +
                in[i*8 + 4] + in[i*8 + 5] + in[i*8 + 6] + in[i*8 + 7];
        end
    endgenerate

    // Count '1's in the remaining 7-bit chunk (bits 248 to 254)
    assign partial_counts[31] = 
        in[248] + in[249] + in[250] + in[251] +
        in[252] + in[253] + in[254];

    // Sum all partial counts
    assign total_count = 
        partial_counts[0]  + partial_counts[1]  + partial_counts[2]  + partial_counts[3]  +
        partial_counts[4]  + partial_counts[5]  + partial_counts[6]  + partial_counts[7]  +
        partial_counts[8]  + partial_counts[9]  + partial_counts[10] + partial_counts[11] +
        partial_counts[12] + partial_counts[13] + partial_counts[14] + partial_counts[15] +
        partial_counts[16] + partial_counts[17] + partial_counts[18] + partial_counts[19] +
        partial_counts[20] + partial_counts[21] + partial_counts[22] + partial_counts[23] +
        partial_counts[24] + partial_counts[25] + partial_counts[26] + partial_counts[27] +
        partial_counts[28] + partial_counts[29] + partial_counts[30] + partial_counts[31];

    assign out = total_count;

endmodule