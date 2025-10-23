module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // First stage: Process 4-bit chunks (25 groups)
    wire [24:0] stage1_and, stage1_or, stage1_xor;
    
    genvar i;
    generate
        for (i = 0; i < 25; i = i + 1) begin : first_stage
            assign stage1_and[i] = &in[(i*4)+3 : i*4];
            assign stage1_or[i]  = |in[(i*4)+3 : i*4];
            assign stage1_xor[i] = ^in[(i*4)+3 : i*4];
        end
    endgenerate

    // Second stage: Combine results
    assign out_and = &stage1_and;
    assign out_or  = |stage1_or;
    assign out_xor = ^stage1_xor;

endmodule