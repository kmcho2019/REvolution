module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    input  logic c,  // Input signal c
    input  logic d,  // Input signal d
    output logic out  // Output signal
);

    // Directly assign the XOR result of a, b, c, and d to out.
    assign out = a ^ b ^ c ^ d;

endmodule