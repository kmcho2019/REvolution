module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Compute even parity of inputs a,b,c,d.
    // q is 1 when the number of 1's in inputs is even.
    assign q = ~(^ {a, b, c, d});
endmodule