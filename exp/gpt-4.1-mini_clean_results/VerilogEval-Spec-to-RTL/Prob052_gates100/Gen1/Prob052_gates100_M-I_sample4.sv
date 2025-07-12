module TopModule (
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Partial reductions: 10 groups of 10 bits
    wire [9:0] and_part;
    wire [9:0] or_part;
    wire [9:0] xor_part;

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : part_reduction
            assign and_part[i] = &in[i*10 +: 10];
            assign or_part[i]  = |in[i*10 +: 10];
            assign xor_part[i] = ^in[i*10 +: 10];
        end
    endgenerate

    // Second level reduction: reduce 10 partial results down to 1
    // For 10 inputs, reduce by grouping 5 and 5, then combine

    // Split into two groups of 5 partials
    wire and_low_5  = &and_part[4:0];
    wire and_high_5 = &and_part[9:5];
    assign out_and = and_low_5 & and_high_5;

    wire or_low_5  = |or_part[4:0];
    wire or_high_5 = |or_part[9:5];
    assign out_or = or_low_5 | or_high_5;

    wire xor_low_5  = ^xor_part[4:0];
    wire xor_high_5 = ^xor_part[9:5];
    assign out_xor = xor_low_5 ^ xor_high_5;

endmodule