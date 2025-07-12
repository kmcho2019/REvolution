module TopModule(
    input  a,
    input  b,
    output out
);

    // Improved XNOR implementation using XOR operator and inverting the output
    assign out = ~(a ^ b);

endmodule