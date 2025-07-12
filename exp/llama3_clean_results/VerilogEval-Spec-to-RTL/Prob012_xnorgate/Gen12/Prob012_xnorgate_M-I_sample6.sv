module TopModule(
    input  a,
    input  b,
    output out
);

    // Improved XNOR implementation using XOR and NOT operators
    assign out = ~(a ^ b);

endmodule