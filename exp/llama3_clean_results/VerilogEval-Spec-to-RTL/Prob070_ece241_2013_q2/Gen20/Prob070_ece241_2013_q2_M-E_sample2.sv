module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Define the sum-of-products expression
assign out_sop = (a == 0 && b == 1 && c == 0 && d == 0) ||
                 (a == 0 && b == 0 && c == 1 && d == 1) ||
                 (a == 1 && b == 1 && c == 1 && d == 1);

// Define the maxterms for product-of-sums
wire m0 = ~(~a & ~b & ~c & ~d);
wire m1 = ~(~a & ~b & ~c & d);
wire m4 = ~(~a & b & ~c & ~d);
wire m5 = ~(~a & b & ~c & d);
wire m6 = ~(~a & b & c & ~d);
wire m9 = ~(a & ~b & ~c & d);
wire m10 = ~(a & ~b & c & ~d);
wire m13 = ~(a & b & ~c & d);
wire m14 = ~(a & b & c & ~d);

// Define the product-of-sums expression
assign out_pos = m0 & m1 & m4 & m5 & m6 & m9 & m10 & m13 & m14;

endmodule