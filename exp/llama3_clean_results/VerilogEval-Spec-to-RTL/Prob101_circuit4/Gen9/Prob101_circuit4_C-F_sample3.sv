module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Using K-map to simplify the logic expression
// The output q is 1 whenever b or c is 1, or when a is 1 and either b or c is 1
assign q = b | c | (a & (b | c));

endmodule