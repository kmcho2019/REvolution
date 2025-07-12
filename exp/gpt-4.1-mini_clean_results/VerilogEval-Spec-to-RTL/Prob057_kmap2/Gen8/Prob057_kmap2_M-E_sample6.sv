module ProductTerm(
    input a,
    input b,
    input c,
    input d,
    input [3:0] mask,  // bits indicate which inputs must be 1: {d,c,b,a}
    input [3:0] value, // bits indicate the values to compare against: {d,c,b,a}
    output match
);
    // For each bit, if mask bit is 1, input must match value bit
    // If mask bit is 0, input is don't care
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
    wire p0, p1, p2, p3;

    // Based on K-map grouping, the four product terms are:

    // Group 1 (top-left 00 00 and 00 01 and 10 00 and 10 01):
    // corresponds to ~d & ~a
    // mask: d and a matter: mask = 1001 (d and a bits), value = 0000 (d=0,a=0)
    ProductTerm pt0(.a(a), .b(b), .c(c), .d(d), .mask(4'b1001), .value(4'b0000), .match(p0));

    // Group 2 (top-left and bottom-left first column): ~c & ~b
    // mask: c and b matter: mask=0110, value=0000
    ProductTerm pt1(.a(a), .b(b), .c(c), .d(d), .mask(4'b0110), .value(4'b0000), .match(p1));

    // Group 3 (bottom right 11 11, 11 10, 11 01): c & d & (a | b)
    // This is a bit complex, so split into two ProductTerm modules for (c & d & a) and (c & d & b)

    // c=1,d=1,a=1,b=don't care
    ProductTerm pt2(.a(a), .b(b), .c(c), .d(d), .mask(4'b1101), .value(4'b1101), .match(p2));
    // c=1,d=1,b=1,a=don't care
    ProductTerm pt3(.a(a), .b(b), .c(c), .d(d), .mask(4'b1110), .value(4'b1110), .match(p3));

    assign out = p0 | p1 | p2 | p3;
endmodule