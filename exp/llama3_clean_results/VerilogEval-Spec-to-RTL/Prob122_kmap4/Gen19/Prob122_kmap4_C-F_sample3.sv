// This module implements the Karnaugh map logic using a direct XOR operation.
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    input  logic c,  // Input signal c
    input  logic d,  // Input signal d
    output logic out  // Output signal
);

    // Directly assign the XOR result of a, b, c, and d to out.
    // This operation directly corresponds to the Karnaugh map's logic.
    assign out = a ^ b ^ c ^ d;

endmodule