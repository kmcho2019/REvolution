module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// The existing expression is already optimized for simplicity and correctness.
// However, to potentially improve PPA, especially power, we ensure the logic is straightforward
// and let the synthesis tool optimize it further with appropriate directives.
assign out = a | (~a & ~b & c);

endmodule