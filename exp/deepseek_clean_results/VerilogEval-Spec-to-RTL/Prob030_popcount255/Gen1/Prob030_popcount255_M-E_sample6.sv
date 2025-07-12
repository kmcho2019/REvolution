module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Stage 1: 85 3-bit groups compressed to 85 sum bits and 85 carry bits
    wire [84:0] stage1_sum, stage1_carry;
    genvar i;
    generate
        for (i = 0; i < 85; i = i + 1) begin : stage1
            assign {stage1_carry[i], stage1_sum[i]} = 
                in[i*3] + in[i*3+1] + in[i*3+2];
        end
    endgenerate

    // Stage 2: Combine sum and carry bits (170 bits total)
    wire [169:0] stage2_in = {stage1_carry, stage1_sum};
    wire [56:0] stage2_sum, stage2_carry;
    generate
        for (i = 0; i < 56; i = i + 1) begin : stage2
            assign {stage2_carry[i], stage2_sum[i]} = 
                stage2_in[i*3] + stage2_in[i*3+1] + stage2_in[i*3+2];
        end
    endgenerate
    // Handle remaining 2 bits
    assign stage2_sum[56] = stage2_in[168] + stage2_in[169];

    // Stage 3: Combine sum and carry bits (113 bits total)
    wire [112:0] stage3_in = {stage2_carry, stage2_sum};
    wire [37:0] stage3_sum, stage3_carry;
    generate
        for (i = 0; i < 37; i = i + 1) begin : stage3
            assign {stage3_carry[i], stage3_sum[i]} = 
                stage3_in[i*3] + stage3_in[i*3+1] + stage3_in[i*3+2];
        end
    endgenerate
    // Handle remaining 2 bits
    assign stage3_sum[37] = stage3_in[111] + stage3_in[112];

    // Stage 4: Combine sum and carry bits (75 bits total)
    wire [74:0] stage4_in = {stage3_carry, stage3_sum};
    wire [24:0] stage4_sum, stage4_carry;
    generate
        for (i = 0; i < 24; i = i + 1) begin : stage4
            assign {stage4_carry[i], stage4_sum[i]} = 
                stage4_in[i*3] + stage4_in[i*3+1] + stage4_in[i*3+2];
        end
    endgenerate
    // Handle remaining 3 bits
    assign {stage4_carry[24], stage4_sum[24]} = 
        stage4_in[72] + stage4_in[73] + stage4_in[74];

    // Stage 5: Combine sum and carry bits (49 bits total)
    wire [48:0] stage5_in = {stage4_carry, stage4_sum};
    wire [16:0] stage5_sum, stage5_carry;
    generate
        for (i = 0; i < 16; i = i + 1) begin : stage5
            assign {stage5_carry[i], stage5_sum[i]} = 
                stage5_in[i*3] + stage5_in[i*3+1] + stage5_in[i*3+2];
        end
    endgenerate
    // Handle remaining 1 bit
    assign stage5_sum[16] = stage5_in[48];

    // Final adder: Combine all remaining bits (33 bits total)
    wire [32:0] final_in = {stage5_carry, stage5_sum};
    assign out = final_in[0] + final_in[1] + final_in[2] + final_in[3] +
                 final_in[4] + final_in[5] + final_in[6] + final_in[7] +
                 final_in[8] + final_in[9] + final_in[10] + final_in[11] +
                 final_in[12] + final_in[13] + final_in[14] + final_in[15] +
                 final_in[16] + final_in[17] + final_in[18] + final_in[19] +
                 final_in[20] + final_in[21] + final_in[22] + final_in[23] +
                 final_in[24] + final_in[25] + final_in[26] + final_in[27] +
                 final_in[28] + final_in[29] + final_in[30] + final_in[31] +
                 final_in[32];

endmodule