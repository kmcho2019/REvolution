module TopModule(
    input  a,
    input  b,
    output out
);

    // Refactored XNOR implementation using XOR and negation
    assign out = ~(a ^ b);

endmodule