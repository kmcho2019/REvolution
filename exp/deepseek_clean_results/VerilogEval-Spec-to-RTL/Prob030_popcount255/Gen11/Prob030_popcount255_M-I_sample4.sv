module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Parameters for flexible design
    parameter LUT_SIZE = 4;  // 4-bit LUTs for counting
    parameter GROUP_SIZE = 8; // Group size for intermediate sums
    
    // First stage: Count 1s in 4-bit chunks using LUTs
    wire [3:0] lut_counts [0:63];
    
    genvar i;
    generate
        for (i = 0; i < 63; i = i + 1) begin : LUT_STAGE
            // Handle full 4-bit groups
            assign lut_counts[i] = (in[i*4] + in[i*4+1] + in[i*4+2] + in[i*4+3]);
        end
        // Handle last 3-bit group (255 bits = 63*4 + 3)
        assign lut_counts[63] = (in[252] + in[253] + in[254]);
    endgenerate

    // Second stage: Sum LUT counts into 8-bit groups
    wire [7:0] group_counts [0:7];
    
    genvar j;
    generate
        for (j = 0; j < 8; j = j + 1) begin : GROUP_STAGE
            if (j < 7) begin
                assign group_counts[j] = lut_counts[j*8]   + lut_counts[j*8+1] +
                                        lut_counts[j*8+2] + lut_counts[j*8+3] +
                                        lut_counts[j*8+4] + lut_counts[j*8+5] +
                                        lut_counts[j*8+6] + lut_counts[j*8+7];
            end else begin
                // Last group has 7 LUT counts (63 total LUTs / 8 groups)
                assign group_counts[7] = lut_counts[56] + lut_counts[57] +
                                        lut_counts[58] + lut_counts[59] +
                                        lut_counts[60] + lut_counts[61] +
                                        lut_counts[62] + lut_counts[63];
            end
        end
    endgenerate

    // Final stage: Balanced binary tree summation
    wire [7:0] stage1 [0:3];
    assign stage1[0] = group_counts[0] + group_counts[1];
    assign stage1[1] = group_counts[2] + group_counts[3];
    assign stage1[2] = group_counts[4] + group_counts[5];
    assign stage1[3] = group_counts[6] + group_counts[7];

    wire [7:0] stage2 [0:1];
    assign stage2[0] = stage1[0] + stage1[1];
    assign stage2[1] = stage1[2] + stage1[3];

    assign out = stage2[0] + stage2[1];

endmodule