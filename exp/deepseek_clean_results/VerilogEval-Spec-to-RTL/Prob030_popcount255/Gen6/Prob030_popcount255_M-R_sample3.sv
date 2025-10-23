module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Stage 1: Count 1s in groups of 3 bits (85 groups)
    wire [6:0] stage1 [0:84];
    genvar i;
    generate
        for (i = 0; i < 85; i = i + 1) begin : STAGE1
            assign stage1[i] = (i*3+0 < 255 ? in[i*3+0] : 0) + 
                              (i*3+1 < 255 ? in[i*3+1] : 0) + 
                              (i*3+2 < 255 ? in[i*3+2] : 0);
        end
    endgenerate

    // Stage 2: Sum stage1 results in groups of 5 (17 groups)
    wire [8:0] stage2 [0:16];
    genvar j;
    generate
        for (j = 0; j < 17; j = j + 1) begin : STAGE2
            assign stage2[j] = (j*5+0 < 85 ? stage1[j*5+0] : 0) +
                              (j*5+1 < 85 ? stage1[j*5+1] : 0) +
                              (j*5+2 < 85 ? stage1[j*5+2] : 0) +
                              (j*5+3 < 85 ? stage1[j*5+3] : 0) +
                              (j*5+4 < 85 ? stage1[j*5+4] : 0);
        end
    endgenerate

    // Stage 3: Sum stage2 results in groups of 3 (6 groups)
    wire [10:0] stage3 [0:5];
    genvar k;
    generate
        for (k = 0; k < 6; k = k + 1) begin : STAGE3
            assign stage3[k] = (k*3+0 < 17 ? stage2[k*3+0] : 0) +
                              (k*3+1 < 17 ? stage2[k*3+1] : 0) +
                              (k*3+2 < 17 ? stage2[k*3+2] : 0);
        end
    endgenerate

    // Final sum of all stage3 results
    assign out = stage3[0] + stage3[1] + stage3[2] + stage3[3] + stage3[4] + stage3[5];

endmodule