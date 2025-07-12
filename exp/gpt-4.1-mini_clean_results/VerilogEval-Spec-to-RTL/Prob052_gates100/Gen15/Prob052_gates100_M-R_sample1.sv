module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // First-level partial reductions: 10 groups of 10 bits
    wire [9:0] and_parts;
    wire [9:0] or_parts;
    wire [9:0] xor_parts;

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : partial_reductions
            assign and_parts[i] = &in[i*10 +: 10];
            assign or_parts[i]  = |in[i*10 +: 10];
            assign xor_parts[i] = ^in[i*10 +: 10];
        end
    endgenerate

    // Second-level final reductions: combine the 10 partial results
    // Reduce AND and OR with reduction operators; XOR with repeated ^
    assign out_and = &and_parts;
    assign out_or  = |or_parts;
    assign out_xor = ^xor_parts;

endmodule