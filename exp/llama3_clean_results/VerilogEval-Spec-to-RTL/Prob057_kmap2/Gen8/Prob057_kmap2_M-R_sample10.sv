module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

wire term1, term2, term3, term4;

// Term 1: (!a && !c)
assign term1 = ~a & ~c;

// Term 2: (b && d)
assign term2 = b & d;

// Term 3: (b && !c)
assign term3 = b & ~c;

// Term 4: (!a && b)
assign term4 = ~a & b;

// Final output: out = term1 || term2 || term3 || term4
assign out = term1 | term2 | term3 | term4;

endmodule