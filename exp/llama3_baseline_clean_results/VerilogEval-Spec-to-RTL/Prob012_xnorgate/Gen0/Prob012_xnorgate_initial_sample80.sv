module TopModule(
    input  a,
    input  b,
    output out
);

assign out = ~(a ^ b); // Using XOR and inversion

// Alternatively, we could also implement it directly as follows:
// assign out = (a == b) ? 1'b1 : 1'b0;

endmodule