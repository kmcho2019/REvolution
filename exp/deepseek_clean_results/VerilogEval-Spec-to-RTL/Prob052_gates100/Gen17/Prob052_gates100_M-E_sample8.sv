module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Stage 1: Process 25 groups of 4 bits each
    wire [24:0] stage1_and, stage1_or, stage1_xor;
    genvar i;
    generate
        for (i = 0; i < 25; i = i + 1) begin : stage1
            localparam hi = (i+1)*4 - 1;
            localparam lo = i*4;
            assign stage1_and[i] = &in[hi:lo];
            assign stage1_or[i]  = |in[hi:lo];
            assign stage1_xor[i] = ^in[hi:lo];
        end
    endgenerate

    // Stage 2: Process 5 groups of 5 bits each
    wire [4:0] stage2_and, stage2_or, stage2_xor;
    genvar j;
    generate
        for (j = 0; j < 5; j = j + 1) begin : stage2
            localparam hi = (j+1)*5 - 1;
            localparam lo = j*5;
            assign stage2_and[j] = &stage1_and[hi:lo];
            assign stage2_or[j]  = |stage1_or[hi:lo];
            assign stage2_xor[j] = ^stage1_xor[hi:lo];
        end
    endgenerate

    // Final reduction
    assign out_and = &stage2_and;
    assign out_or  = |stage2_or;
    assign out_xor = ^stage2_xor;

endmodule