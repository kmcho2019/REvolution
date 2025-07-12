// TopModule implements the Karnaugh map logic using XOR operations.
// It takes four inputs (a, b, c, d) and produces one output (out).
module TopModule(
    input  a,  // Input a
    input  b,  // Input b
    input  c,  // Input c
    input  d,  // Input d
    output out  // Output out
);

    // Directly assign the XOR result of a, b, c, and d to out.
    // This implements the Karnaugh map logic in a concise and efficient manner.
    assign out = a ^ b ^ c ^ d;

endmodule