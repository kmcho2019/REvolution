module TopModule(
    input  a,
    input  b,
    output out
);

    // Intermediate wire to hold the XOR result
    wire xor_result;

    // Implement XOR operation
    assign xor_result = a ^ b;

    // Invert the XOR result to get XNOR
    assign out = ~xor_result;

endmodule