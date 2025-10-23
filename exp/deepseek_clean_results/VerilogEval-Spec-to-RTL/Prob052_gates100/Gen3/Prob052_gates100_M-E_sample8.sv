module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // First stage: Process 10 groups of 10 bits each
    wire [9:0] and_stage1;
    wire [9:0] or_stage1;
    wire [9:0] xor_stage1;

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : group_processing
            assign and_stage1[i] = &in[i*10 +: 10];
            assign or_stage1[i]  = |in[i*10 +: 10];
            assign xor_stage1[i] = ^in[i*10 +: 10];
        end
    endgenerate

    // Second stage: Combine the 10 intermediate results
    assign out_and = &and_stage1;
    assign out_or  = |or_stage1;
    assign out_xor = ^xor_stage1;

endmodule