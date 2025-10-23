module TopModule(
    input  a,
    input  b,
    output out
);

    // Refactored XNOR implementation using XOR and NOT operators
    assign out = ~(a ^ b);

endmodule