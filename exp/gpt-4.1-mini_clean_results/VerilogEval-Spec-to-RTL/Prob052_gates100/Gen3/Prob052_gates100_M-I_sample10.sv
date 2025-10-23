module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);
    // Partial reductions for groups of 10 bits
    wire [9:0] and_part;
    wire [9:0] or_part;
    wire [9:0] xor_part;

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : group_reduce
            assign and_part[i] = &in[i*10 +: 10];
            assign or_part[i]  = |in[i*10 +: 10];
            assign xor_part[i] = ^in[i*10 +: 10];
        end
    endgenerate

    // Final reduction of partial results
    assign out_and = &and_part;
    assign out_or  = |or_part;
    assign out_xor = ^xor_part;
endmodule