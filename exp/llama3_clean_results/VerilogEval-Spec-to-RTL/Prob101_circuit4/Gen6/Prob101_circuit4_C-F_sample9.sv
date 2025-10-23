module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Using K-map to simplify the logic expression
// The output q is 1 whenever b or c is 1, regardless of the values of a and d
assign q = b | c;

endmodule