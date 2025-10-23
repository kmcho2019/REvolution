module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Stage 1: Count 1s in 15-bit chunks (17 chunks total)
    wire [3:0] chunk_counts [0:16];
    
    genvar i;
    generate
        for (i = 0; i < 17; i = i + 1) begin : COUNT_CHUNKS
            // Process each 15-bit chunk (last chunk has only 15 bits)
            localparam end_bit = (i == 16) ? 254 : (i*15 + 14);
            assign chunk_counts[i] = 
                in[end_bit-0] + in[end_bit-1] + in[end_bit-2] + in[end_bit-3] + in[end_bit-4] +
                in[end_bit-5] + in[end_bit-6] + in[end_bit-7] + in[end_bit-8] + in[end_bit-9] +
                in[end_bit-10] + in[end_bit-11] + in[end_bit-12] + in[end_bit-13] + in[end_bit-14];
        end
    endgenerate

    // Stage 2: Sum chunks in groups of 4 (first 16 chunks)
    wire [5:0] group_sums [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : SUM_GROUPS
            assign group_sums[i] = chunk_counts[i*4] + chunk_counts[i*4+1] + 
                                  chunk_counts[i*4+2] + chunk_counts[i*4+3];
        end
    endgenerate

    // Stage 3: Sum remaining chunk (17th) with intermediate sums
    wire [7:0] final_sum = group_sums[0] + group_sums[1] + group_sums[2] + 
                          group_sums[3] + chunk_counts[16];

    assign out = final_sum;

endmodule