module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // Intermediate signals for groups of 10 bits
    wire [9:0] and_groups;
    wire [9:0] or_groups;
    wire [9:0] xor_groups;

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : group_reduce
            assign and_groups[i] = &in[i*10 +: 10];
            assign or_groups[i]  = |in[i*10 +: 10];
            assign xor_groups[i] = ^in[i*10 +: 10];
        end
    endgenerate

    // Final reductions on the 10 groups
    assign out_and = &and_groups;
    assign out_or  = |or_groups;
    assign out_xor = ^xor_groups;

endmodule