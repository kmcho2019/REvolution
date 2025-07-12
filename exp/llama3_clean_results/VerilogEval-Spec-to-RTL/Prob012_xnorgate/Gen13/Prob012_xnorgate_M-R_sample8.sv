module TopModule(
    input  a,
    input  b,
    output out
);

    // Local wire to hold the XOR result
    wire xor_result;

    // Compute XOR of a and b
    assign xor_result = a ^ b;

    // Invert the XOR result to get XNOR
    assign out = ~xor_result;

endmodule