module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

    // Define intermediate signals for XOR operations
    wire ab_xor; // XOR of a and b
    wire cd_xor; // XOR of c and d

    // Assign XOR operations to intermediate signals
    assign ab_xor = a ^ b;
    assign cd_xor = c ^ d;

    // Directly express the output using the intermediate signals
    assign out = ab_xor ^ cd_xor;

endmodule