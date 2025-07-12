module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Intermediate results for groups of 10 bits
    wire [9:0] and_groups;
    wire [9:0] or_groups;
    wire [9:0] xor_groups;

    // Compute intermediate results for each group
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : group_logic
            assign and_groups[i] = &in[i*10 +: 10];
            assign or_groups[i]  = |in[i*10 +: 10];
            assign xor_groups[i] = ^in[i*10 +: 10];
        end
    endgenerate

    // Combine intermediate results
    assign out_and = &and_groups;
    assign out_or  = |or_groups;
    assign out_xor = ^xor_groups;

endmodule