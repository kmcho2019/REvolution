module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // First level: Sum bits in groups of 8 (31 full bytes + 7 remaining bits)
    wire [3:0] byte_counts [0:30];
    wire [2:0] remainder_count;
    
    genvar i;
    generate
        // Count 1s in each full byte (31 bytes)
        for (i = 0; i < 31; i = i + 1) begin : BYTE_COUNTS
            assign byte_counts[i] = in[i*8]   + in[i*8+1] + in[i*8+2] + in[i*8+3] +
                                   in[i*8+4] + in[i*8+5] + in[i*8+6] + in[i*8+7];
        end
        
        // Count 1s in remaining 7 bits (bits 248-254)
        assign remainder_count = in[248] + in[249] + in[250] + in[251] + 
                                 in[252] + in[253] + in[254];
    endgenerate

    // Sum all byte counts and remainder
    wire [7:0] total = byte_counts[0]  + byte_counts[1]  + byte_counts[2]  +
                       byte_counts[3]  + byte_counts[4]  + byte_counts[5]  +
                       byte_counts[6]  + byte_counts[7]  + byte_counts[8]  +
                       byte_counts[9]  + byte_counts[10] + byte_counts[11] +
                       byte_counts[12] + byte_counts[13] + byte_counts[14] +
                       byte_counts[15] + byte_counts[16] + byte_counts[17] +
                       byte_counts[18] + byte_counts[19] + byte_counts[20] +
                       byte_counts[21] + byte_counts[22] + byte_counts[23] +
                       byte_counts[24] + byte_counts[25] + byte_counts[26] +
                       byte_counts[27] + byte_counts[28] + byte_counts[29] +
                       byte_counts[30] + remainder_count;

    assign out = total;

endmodule