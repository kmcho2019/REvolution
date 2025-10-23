module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Level 1: Count '1's in 8-bit chunks (32 chunks total: 31 full + 1 partial)
    wire [3:0] level1 [0:31];
    genvar i;
    generate
        // Count full 8-bit chunks (first 31 chunks)
        for (i = 0; i < 31; i = i + 1) begin : count_8bit
            assign level1[i] = 
                in[i*8 + 0] + in[i*8 + 1] + in[i*8 + 2] + in[i*8 + 3] +
                in[i*8 + 4] + in[i*8 + 5] + in[i*8 + 6] + in[i*8 + 7];
        end
        // Count remaining 7-bit chunk (bits 248-254)
        assign level1[31] = 
            in[248] + in[249] + in[250] + in[251] +
            in[252] + in[253] + in[254];
    endgenerate

    // Level 2: 4:1 reduction (8 groups)
    wire [5:0] level2 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : level2_adders
            assign level2[i] = level1[i*4] + level1[i*4+1] + level1[i*4+2] + level1[i*4+3];
        end
    endgenerate

    // Level 3: Final 2:1 reduction (4 groups)
    wire [7:0] level3 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : level3_adders
            assign level3[i] = level2[i*2] + level2[i*2+1];
        end
    endgenerate

    // Final addition - optimized carry-save style
    wire [7:0] sum_01 = level3[0] + level3[1];
    wire [7:0] sum_23 = level3[2] + level3[3];
    assign out = sum_01 + sum_23;

endmodule