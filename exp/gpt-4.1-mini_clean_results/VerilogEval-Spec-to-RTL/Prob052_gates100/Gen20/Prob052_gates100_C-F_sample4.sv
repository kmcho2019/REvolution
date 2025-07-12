module TopModule (
    input  [99:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    wire [9:0] and_group;
    wire [9:0] or_group;
    wire [9:0] xor_group;

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : group_reductions
            assign and_group[i] = &in[i*10 +: 10];  // AND reduction of each 10-bit group
            assign or_group[i]  = |in[i*10 +: 10];  // OR  reduction of each 10-bit group
            assign xor_group[i] = ^in[i*10 +: 10];  // XOR reduction of each 10-bit group
        end
    endgenerate

    // Final reductions over the intermediate group results
    assign out_and = &and_group;
    assign out_or  = |or_group;
    assign out_xor = ^xor_group;

endmodule