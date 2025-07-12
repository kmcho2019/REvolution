module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Stage 1: 4-bit LUT-based counting (64 groups)
    wire [3:0] stage1 [0:63];
    genvar i;
    generate
        for (i = 0; i < 63; i = i + 1) begin : LUT4
            assign stage1[i] = in[i*4+3] + in[i*4+2] + in[i*4+1] + in[i*4];
        end
        // Last 3-bit group
        assign stage1[63] = in[254] + in[253] + in[252];
    endgenerate

    // Stage 2: First level of adder tree (32 groups of 2)
    wire [4:0] stage2 [0:31];
    generate
        for (i = 0; i < 32; i = i + 1) begin : ADD5
            assign stage2[i] = stage1[i*2] + stage1[i*2+1];
        end
    endgenerate

    // Stage 3: Second level of adder tree (16 groups of 2)
    wire [5:0] stage3 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : ADD6
            assign stage3[i] = stage2[i*2] + stage2[i*2+1];
        end
    endgenerate

    // Stage 4: Third level of adder tree (8 groups of 2)
    wire [6:0] stage4 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : ADD7
            assign stage4[i] = stage3[i*2] + stage3[i*2+1];
        end
    endgenerate

    // Stage 5: Final reduction (4 groups of 2)
    wire [7:0] stage5 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : ADD8
            assign stage5[i] = stage4[i*2] + stage4[i*2+1];
        end
    endgenerate

    // Final sum
    assign out = stage5[0] + stage5[1] + stage5[2] + stage5[3];

endmodule