module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Count '1's in 8-bit chunks (32 full chunks + 1 partial chunk)
    wire [3:0] partial_counts [0:31];
    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : byte_counters
            assign partial_counts[i] = in[i*8 + 0] + in[i*8 + 1] + 
                                     in[i*8 + 2] + in[i*8 + 3] + 
                                     in[i*8 + 4] + in[i*8 + 5] + 
                                     in[i*8 + 6] + in[i*8 + 7];
        end
        // Last partial chunk (7 bits)
        assign partial_counts[31] = in[248] + in[249] + in[250] + 
                                  in[251] + in[252] + in[253] + in[254];
    endgenerate

    // Sum all partial counts
    wire [7:0] total = partial_counts[0] + partial_counts[1] + 
                      partial_counts[2] + partial_counts[3] + 
                      partial_counts[4] + partial_counts[5] + 
                      partial_counts[6] + partial_counts[7] + 
                      partial_counts[8] + partial_counts[9] + 
                      partial_counts[10] + partial_counts[11] + 
                      partial_counts[12] + partial_counts[13] + 
                      partial_counts[14] + partial_counts[15] + 
                      partial_counts[16] + partial_counts[17] + 
                      partial_counts[18] + partial_counts[19] + 
                      partial_counts[20] + partial_counts[21] + 
                      partial_counts[22] + partial_counts[23] + 
                      partial_counts[24] + partial_counts[25] + 
                      partial_counts[26] + partial_counts[27] + 
                      partial_counts[28] + partial_counts[29] + 
                      partial_counts[30] + partial_counts[31];

    assign out = total;

endmodule