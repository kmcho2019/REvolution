module TopModule(
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic out
);

    // Intermediate signals for XOR operations
    logic ab_xor;
    logic cd_xor;

    // Compute XOR of a and b
    assign ab_xor = a ^ b;

    // Compute XOR of c and d
    assign cd_xor = c ^ d;

    // Final output is XOR of ab_xor and cd_xor
    assign out = ab_xor ^ cd_xor;

endmodule