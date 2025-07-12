module TopModule(
    input  a,
    input  b,
    output out
);

assign out = ~(a ^ b); // Using XOR and inverting the result, as XNOR is equivalent to ~(a ^ b)

endmodule