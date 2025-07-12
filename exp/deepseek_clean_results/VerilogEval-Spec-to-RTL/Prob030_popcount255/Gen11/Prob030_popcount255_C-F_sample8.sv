module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // First level: Sum bits in groups of 3 (85 groups)
    wire [6:0] level1 [0:84];
    genvar i;
    generate
        for (i = 0; i < 85; i = i + 1) begin : LEVEL1
            localparam end_bit = (i*3+2 > 254) ? 254 : i*3+2;
            localparam num_bits = end_bit - i*3 + 1;
            
            if (num_bits == 3) begin
                assign level1[i] = in[i*3] + in[i*3+1] + in[i*3+2];
            end else if (num_bits == 2) begin
                assign level1[i] = in[i*3] + in[i*3+1];
            end else begin
                assign level1[i] = in[i*3];
            end
        end
    endgenerate

    // Second level: Sum level1 results in groups of 5 (17 groups)
    wire [8:0] level2 [0:16];
    generate
        for (i = 0; i < 17; i = i + 1) begin : LEVEL2
            localparam end_group = (i*5+4 > 84) ? 84 : i*5+4;
            localparam num_groups = end_group - i*5 + 1;
            
            if (num_groups == 5) begin
                assign level2[i] = level1[i*5] + level1[i*5+1] + level1[i*5+2] + 
                                  level1[i*5+3] + level1[i*5+4];
            end else if (num_groups == 4) begin
                assign level2[i] = level1[i*5] + level1[i*5+1] + 
                                  level1[i*5+2] + level1[i*5+3];
            end else if (num_groups == 3) begin
                assign level2[i] = level1[i*5] + level1[i*5+1] + level1[i*5+2];
            end else if (num_groups == 2) begin
                assign level2[i] = level1[i*5] + level1[i*5+1];
            end else begin
                assign level2[i] = level1[i*5];
            end
        end
    endgenerate

    // Final sum in two stages for better timing
    wire [8:0] stage1_sum [0:4];
    assign stage1_sum[0] = level2[0] + level2[1] + level2[2] + level2[3];
    assign stage1_sum[1] = level2[4] + level2[5] + level2[6] + level2[7];
    assign stage1_sum[2] = level2[8] + level2[9] + level2[10] + level2[11];
    assign stage1_sum[3] = level2[12] + level2[13] + level2[14] + level2[15];
    assign stage1_sum[4] = level2[16];

    // Final output
    assign out = stage1_sum[0] + stage1_sum[1] + 
                 stage1_sum[2] + stage1_sum[3] + 
                 stage1_sum[4];

endmodule