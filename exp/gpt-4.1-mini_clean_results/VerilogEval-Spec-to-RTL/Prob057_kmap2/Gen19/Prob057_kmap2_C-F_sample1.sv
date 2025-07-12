module ProductTerm(
    input  a,
    input  b,
    input  c,
    input  d,
    input  [3:0] mask,  // bit mask indicating relevant inputs: {d,c,b,a}
    input  [3:0] value, // bit values for relevant inputs: {d,c,b,a}
    output match
);
    // Match when for each relevant bit, input equals value
    // Use XOR and mask to create difference mask, then check zero
    wire [3:0] diff = ( {d,c,b,a} ^ value ) & mask;
    assign match = (diff == 4'b0000);
endmodule

module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Shared inverted inputs
    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    // Shared OR signals
    wire or_ab  = a | b;
    wire or_nab = na | nb;

    // Three simple product terms implemented directly for minimal area/power
    wire p1 = nc & nd & or_nab;  // ~c & ~d & (~a | ~b)
    wire p2 = nc & d  & nb;      // ~c & d  & ~b
    wire p3 = c  & nd & na;      // c  & ~d & ~a

    // Complex product term c & d & (a | b) implemented with ProductTerm module instances
    // Represent (c=1,d=1,a=1,b=don't care) and (c=1,d=1,b=1,a=don't care)
    wire p4a, p4b;
    // mask bits: {d,c,b,a}
    // p4a: c=1,d=1,a=1,b=don't care => mask=1101, value=1101
    ProductTerm pt_a (.a(a), .b(b), .c(c), .d(d), .mask(4'b1101), .value(4'b1101), .match(p4a));
    // p4b: c=1,d=1,b=1,a=don't care => mask=1110, value=1110
    ProductTerm pt_b (.a(a), .b(b), .c(c), .d(d), .mask(4'b1110), .value(4'b1110), .match(p4b));

    wire p4 = p4a | p4b;

    // Final output: OR all product terms
    assign out = p1 | p2 | p3 | p4;

endmodule