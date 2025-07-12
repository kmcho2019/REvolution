module TopModule(
    input  a,
    input  b,
    output out
);

assign out = (a == b) ? 1'b1 : 1'b0;

// Alternatively, we can use the bitwise XOR operator (^) and then invert the result
// assign out = ~(a ^ b);

endmodule