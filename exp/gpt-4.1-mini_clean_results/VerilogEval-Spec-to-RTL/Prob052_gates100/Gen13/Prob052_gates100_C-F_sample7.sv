module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);
    // First level: 10 groups of 10 bits partial reductions using built-in operators
    wire [9:0] and_lvl1;
    wire [9:0] or_lvl1;
    wire [9:0] xor_lvl1;

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : level1_reduce
            assign and_lvl1[i] = &in[i*10 +: 10];
            assign or_lvl1[i]  = |in[i*10 +: 10];
            assign xor_lvl1[i] = ^in[i*10 +: 10];
        end
    endgenerate

    // Second level: reduce pairs of level1 results to 5 bits
    wire [4:0] and_lvl2;
    wire [4:0] or_lvl2;
    wire [4:0] xor_lvl2;

    generate
        for (i = 0; i < 5; i = i + 1) begin : level2_reduce
            assign and_lvl2[i] = and_lvl1[2*i] & and_lvl1[2*i+1];
            assign or_lvl2[i]  = or_lvl1[2*i] | or_lvl1[2*i+1];
            assign xor_lvl2[i] = xor_lvl1[2*i] ^ xor_lvl1[2*i+1];
        end
    endgenerate

    // Third level:
    // AND and OR: reduce 5 bits with reduction operators for clarity and synthesis efficiency
    assign out_and = &and_lvl2;
    assign out_or  = |or_lvl2;

    // XOR: reduce 5 bits with chained XOR (which is associative)
    assign out_xor = ^xor_lvl2;

endmodule