module ProductTerm(
    input a,
    input b,
    input c,
    input d,
    input [3:0] mask,  // bit mask indicating which inputs are relevant: {d,c,b,a}
    input [3:0] value, // bit values required for relevant inputs: {d,c,b,a}
    output match
);
    // For relevant bits (mask=1), input must equal value; else don't-care (always true)
    wire cond_a = (mask[0]) ? (a == value[0]) : 1'b1;
    wire cond_b = (mask[1]) ? (b == value[1]) : 1'b1;
    wire cond_c = (mask[2]) ? (c == value[2]) : 1'b1;
    wire cond_d = (mask[3]) ? (d == value[3]) : 1'b1;

    assign match = cond_a & cond_b & cond_c & cond_d;
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

    // Group 4: (c & d & (a | b)) - complex group implemented using ProductTerm submodules
    // Instead of two separate terms for (c&d&a) and (c&d&b), use ProductTerm with a mask/value for each minterm and OR them
    wire p4a, p4b;

    // c=1,d=1,a=1,b=don't care: mask bits {d,c,b,a} = 1101, value = 1101
    ProductTerm pt_a(.a(a), .b(b), .c(c), .d(d), .mask(4'b1101), .value(4'b1101), .match(p4a));

    // c=1,d=1,b=1,a=don't care: mask bits = 1110, value = 1110
    ProductTerm pt_b(.a(a), .b(b), .c(c), .d(d), .mask(4'b1110), .value(4'b1110), .match(p4b));

    wire group4 = p4a | p4b;

    // Final output is OR of all groups
    assign out = group1 | group2 | group3 | group4;

endmodule