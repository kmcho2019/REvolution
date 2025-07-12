module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    wire [9:0] and_group;
    wire [9:0] or_group;
    wire [9:0] xor_group;

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : group_reduction
            // Use built-in reduction operators for each group of 10 bits
            assign and_group[i] = &in[i*10 +: 10];
            assign or_group[i]  = |in[i*10 +: 10];
            assign xor_group[i] = ^in[i*10 +: 10];
        end
    endgenerate

    // Final reductions on the groups
    assign out_and = &and_group;
    assign out_or  = |or_group;
    assign out_xor = ^xor_group;

endmodule