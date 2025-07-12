module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    input  logic c,  // Input signal c
    input  logic d,  // Input signal d
    output logic out  // Output signal
);

    // Use an always block with a combinational logic
    always @(*) begin
        // Directly assign the XOR result of a, b, c, and d to out
        out = a ^ b ^ c ^ d;
    end

endmodule