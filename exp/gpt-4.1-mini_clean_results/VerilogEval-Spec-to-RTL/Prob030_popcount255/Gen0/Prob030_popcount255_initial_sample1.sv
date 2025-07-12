module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // First, break input into 8-bit chunks (last chunk is 255 - 8*31 = 7 bits)
    wire [7:0] partial_sums [31:0];
    
    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : chunk_sum
            // Sum each 8-bit chunk
            assign partial_sums[i] = in[i*8 +: 8];
        end
    endgenerate
    
    // The last chunk is only 7 bits
    assign partial_sums[31] = {1'b0, in[254 -: 7]};
    
    // Sum the partial sums to get the final population count
    // Use a reduction by summing in stages:
    wire [11:0] level1 [15:0];
    generate
        for (i = 0; i < 16; i = i + 1) begin : sum_level1
            assign level1[i] = partial_sums[2*i] + partial_sums[2*i+1];
        end
    endgenerate
    
    wire [12:0] level2 [7:0];
    generate
        for (i = 0; i < 8; i = i + 1) begin : sum_level2
            assign level2[i] = level1[2*i] + level1[2*i+1];
        end
    endgenerate
    
    wire [13:0] level3 [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : sum_level3
            assign level3[i] = level2[2*i] + level2[2*i+1];
        end
    endgenerate
    
    wire [14:0] level4 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : sum_level4
            assign level4[i] = level3[2*i] + level3[2*i+1];
        end
    endgenerate
    
    wire [15:0] level5;
    assign level5 = level4[0] + level4[1];
    
    // The final sum fits into 8 bits because max is 255
    assign out = level5[7:0];
    
endmodule