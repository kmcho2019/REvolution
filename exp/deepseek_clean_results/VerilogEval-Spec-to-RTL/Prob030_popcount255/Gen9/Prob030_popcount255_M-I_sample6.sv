module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Level 1: Count '1's in 4-bit chunks (63 full + 3 partial)
    wire [2:0] level1 [0:63];  // 3 bits per counter (max 4)
    genvar i;
    generate
        for (i = 0; i < 63; i = i + 1) begin : level1_counters
            assign level1[i] = in[i*4] + in[i*4+1] + in[i*4+2] + in[i*4+3];
        end
        // Handle last partial chunk (3 bits)
        assign level1[63] = in[252] + in[253] + in[254];
    endgenerate

    // Level 2: Sum 4 level1 counters (16 groups)
    wire [4:0] level2 [0:15];  // 5 bits needed (max 16)
    generate
        for (i = 0; i < 15; i = i + 1) begin : level2_adders
            assign level2[i] = level1[i*4] + level1[i*4+1] + level1[i*4+2] + level1[i*4+3];
        end
        // Last group has 4 counters (3 from full + 1 from partial)
        assign level2[15] = level1[60] + level1[61] + level1[62] + level1[63];
    endgenerate

    // Final balanced binary tree addition
    wire [7:0] sum0_3, sum4_7, sum8_11, sum12_15;
    wire [7:0] sum0_7, sum8_15;
    
    assign sum0_3 = level2[0] + level2[1] + level2[2] + level2[3];
    assign sum4_7 = level2[4] + level2[5] + level2[6] + level2[7];
    assign sum8_11 = level2[8] + level2[9] + level2[10] + level2[11];
    assign sum12_15 = level2[12] + level2[13] + level2[14] + level2[15];
    
    assign sum0_7 = sum0_3 + sum4_7;
    assign sum8_15 = sum8_11 + sum12_15;
    
    assign out = sum0_7 + sum8_15;

endmodule