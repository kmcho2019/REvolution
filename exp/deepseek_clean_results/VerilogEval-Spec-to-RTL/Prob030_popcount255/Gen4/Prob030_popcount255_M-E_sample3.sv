module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Stage 1: Parallel 5-bit population counts
    wire [5:0] stage1 [0:50]; // 51 groups of 5 bits (255 total)
    genvar i;
    generate
        for (i = 0; i < 51; i = i + 1) begin : STAGE1
            assign stage1[i] = 
                in[i*5 + 0] + in[i*5 + 1] + in[i*5 + 2] + 
                in[i*5 + 3] + in[i*5 + 4];
        end
    endgenerate

    // Stage 2: First level of reduction (3:2 compressors)
    wire [6:0] stage2 [0:16];
    generate
        for (i = 0; i < 17; i = i + 1) begin : STAGE2
            assign stage2[i] = stage1[i*3] + stage1[i*3 + 1] + stage1[i*3 + 2];
        end
    endgenerate

    // Stage 3: Second level of reduction
    wire [7:0] stage3 [0:5];
    assign stage3[0] = stage2[0] + stage2[1] + stage2[2];
    assign stage3[1] = stage2[3] + stage2[4] + stage2[5];
    assign stage3[2] = stage2[6] + stage2[7] + stage2[8];
    assign stage3[3] = stage2[9] + stage2[10] + stage2[11];
    assign stage3[4] = stage2[12] + stage2[13] + stage2[14];
    assign stage3[5] = stage2[15] + stage2[16];

    // Final summation
    assign out = stage3[0] + stage3[1] + stage3[2] + 
                 stage3[3] + stage3[4] + stage3[5];

endmodule