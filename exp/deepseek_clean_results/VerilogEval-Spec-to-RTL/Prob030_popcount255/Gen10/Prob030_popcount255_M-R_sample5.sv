module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // First stage: Sum bits in groups of 4 (64 groups)
    wire [2:0] stage1 [0:63];
    genvar i;
    generate
        for (i = 0; i < 63; i = i + 1) begin : STAGE1
            assign stage1[i] = in[i*4] + in[i*4+1] + in[i*4+2] + in[i*4+3];
        end
        // Handle the remaining 3 bits (255 = 63*4 + 3)
        assign stage1[63] = in[252] + in[253] + in[254];
    endgenerate

    // Second stage: Sum stage1 results in groups of 4 (16 groups)
    wire [4:0] stage2 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : STAGE2
            assign stage2[i] = stage1[i*4] + stage1[i*4+1] + stage1[i*4+2] + stage1[i*4+3];
        end
    endgenerate

    // Third stage: Sum stage2 results in groups of 4 (4 groups)
    wire [6:0] stage3 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : STAGE3
            assign stage3[i] = stage2[i*4] + stage2[i*4+1] + stage2[i*4+2] + stage2[i*4+3];
        end
    endgenerate

    // Final sum of all stage3 results
    assign out = stage3[0] + stage3[1] + stage3[2] + stage3[3];

endmodule