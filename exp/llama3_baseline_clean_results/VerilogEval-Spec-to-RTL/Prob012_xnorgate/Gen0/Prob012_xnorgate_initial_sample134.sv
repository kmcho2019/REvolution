module TopModule(
    input  a,
    input  b,
    output out
);

assign out = ~(a ^ b); // XNOR using XOR and inverting the result

endmodule