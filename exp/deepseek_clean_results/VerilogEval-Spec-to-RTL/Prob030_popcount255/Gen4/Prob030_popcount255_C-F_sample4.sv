module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // First level: Count '1's in each 5-bit chunk (51 chunks)
    wire [4:0] chunk_counts [0:50];
    genvar i;
    generate
        for (i = 0; i < 51; i = i + 1) begin : count_chunks
            if (i < 50) begin : normal_chunks
                assign chunk_counts[i] = 
                    in[i*5 + 0] + in[i*5 + 1] + 
                    in[i*5 + 2] + in[i*5 + 3] + 
                    in[i*5 + 4];
            end else begin : last_chunk  // Last chunk has 5 bits (255 - 50*5)
                assign chunk_counts[i] = 
                    in[250] + in[251] + 
                    in[252] + in[253] + 
                    in[254];
            end
        end
    endgenerate

    // Second level: Sum 51 chunks into 17 sums (3 chunks each)
    wire [6:0] level1 [0:16];
    generate
        for (i = 0; i < 17; i = i + 1) begin : sum_level1
            if (i < 16) begin : normal_sums
                assign level1[i] = chunk_counts[i*3] + chunk_counts[i*3 + 1] + chunk_counts[i*3 + 2];
            end else begin : last_sum  // Last sum has 3 chunks (51 - 16*3)
                assign level1[i] = chunk_counts[48] + chunk_counts[49] + chunk_counts[50];
            end
        end
    endgenerate

    // Third level: Sum 17 into 6 sums (3 sums each)
    wire [8:0] level2 [0:5];
    generate
        for (i = 0; i < 6; i = i + 1) begin : sum_level2
            if (i < 5) begin : normal_sums
                assign level2[i] = level1[i*3] + level1[i*3 + 1] + level1[i*3 + 2];
            end else begin : last_sum  // Last sum has 2 sums (17 - 5*3)
                assign level2[i] = level1[15] + level1[16];
            end
        end
    endgenerate

    // Fourth level: Sum 6 into 2 sums (3 sums each)
    wire [9:0] level3 [0:1];
    generate
        for (i = 0; i < 2; i = i + 1) begin : sum_level3
            assign level3[i] = level2[i*3] + level2[i*3 + 1] + level2[i*3 + 2];
        end
    endgenerate

    // Final sum
    assign out = level3[0] + level3[1];

endmodule