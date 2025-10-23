module ProductTerm(
    input a,
    input b,
    input c,
    input d,
    input [3:0] mask,   // bit mask for inputs: {d,c,b,a}
    input [3:0] value,  // required bit values for masked inputs
    output match
);
    // Apply mask and compare masked bits: (input & mask) == (value & mask)
    // Using bitwise operations and equality checks simplifies the logic.
    wire [3:0] in_bits = {d, c, b, a};
    assign match = ((in_bits & mask) == (value & mask));
endmodule

module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Shared inverted inputs for reuse
    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    // Group 1: (~c & ~d & (~a | ~b))
    wire group1 = nc & nd & (na | nb);

    // Group 2: (~c & d & ~b)
    wire group2 = nc & d & nb;

    // Group 3: (c & ~d & ~a)
    wire group3 = c & nd & na;

    // Group 4: (c & d & (a | b)) - implemented using the simplified ProductTerm module
    // Represent the two minterms (c=1,d=1,a=1,b=x) and (c=1,d=1,a=x,b=1) as two ProductTerms
    wire p4a, p4b;

    // Mask and value for c=1,d=1,a=1,b don't care: mask=1101, value=1101 (bits {d,c,b,a})
    ProductTerm pt_a (
        .a(a), .b(b), .c(c), .d(d),
        .mask(4'b1101),
        .value(4'b1101),
        .match(p4a)
    );

    // Mask and value for c=1,d=1,b=1,a don't care: mask=1110, value=1110
    ProductTerm pt_b (
        .a(a), .b(b), .c(c), .d(d),
        .mask(4'b1110),
        .value(4'b1110),
        .match(p4b)
    );

    wire group4 = p4a | p4b;

    // Final output is OR of all groups
    assign out = group1 | group2 | group3 | group4;

endmodule