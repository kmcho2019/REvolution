module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    input  logic c,  // Input signal c
    input  logic d,  // Input signal d
    output logic out  // Output signal
);

    // Implement the XOR operation among all inputs within an always block
    // for flexibility and potential future modifications.
    always @(*) begin
        // Directly assign the XOR result of a, b, c, and d to out.
        out = a ^ b ^ c ^ d;
    end

endmodule