module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Output q is the even parity of inputs a, b, c, and d
    // It is 1 when an even number of inputs are 1, else 0
    assign q = ~(a ^ b ^ c ^ d);

endmodule