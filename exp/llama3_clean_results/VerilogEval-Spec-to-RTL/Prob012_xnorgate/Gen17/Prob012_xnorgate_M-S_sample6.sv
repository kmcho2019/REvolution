module TopModule(
    input  a,
    input  b,
    output out
);

    // Simplified XNOR implementation using XOR and NOT operators
    assign out = ~(a ^ b);

endmodule