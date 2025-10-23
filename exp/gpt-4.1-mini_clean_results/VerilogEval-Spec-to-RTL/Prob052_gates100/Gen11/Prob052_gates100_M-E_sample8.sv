module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);
    // Partition input into 10 groups of 10 bits
    wire [9:0] and_partials;
    wire [9:0] or_partials;
    wire [9:0] xor_partials;

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : PARTIAL_REDUCTIONS
            assign and_partials[i] = &in[i*10 +: 10];
            assign or_partials[i]  = |in[i*10 +: 10];
            assign xor_partials[i] = ^in[i*10 +: 10];
        end
    endgenerate

    // Combine partial results hierarchically
    wire and_upper, or_upper, xor_upper;
    assign and_upper = &and_partials;  // AND of partial ANDs
    assign or_upper  = |or_partials;   // OR of partial ORs
    assign xor_upper = ^xor_partials;  // XOR of partial XORs

    assign out_and = and_upper;
    assign out_or  = or_upper;
    assign out_xor = xor_upper;

endmodule