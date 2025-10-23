module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // Stage 1: Reduce every 10 inputs into one intermediate signal for each function
    wire [9:0] and_stage1;
    wire [9:0] or_stage1;
    wire [9:0] xor_stage1;

    genvar i, j;
    generate
        for (i = 0; i < 10; i = i + 1) begin : stage1_reduction
            wire [9:0] chunk = in[i*10 +: 10];

            assign and_stage1[i] = &chunk;
            assign or_stage1[i]  = |chunk;
            assign xor_stage1[i] = ^chunk;
        end
    endgenerate

    // Stage 2: Reduce the 10 intermediate signals into final outputs
    assign out_and = &and_stage1;
    assign out_or  = |or_stage1;
    assign out_xor = ^xor_stage1;

endmodule