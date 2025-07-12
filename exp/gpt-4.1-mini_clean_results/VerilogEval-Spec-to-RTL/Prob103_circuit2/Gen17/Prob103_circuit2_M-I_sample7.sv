module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// q is 1 if the number of inputs set to 1 is even (even parity)
// Using reduction XNOR operator for direct even parity calculation
assign q = ~^ {a, b, c, d};

endmodule