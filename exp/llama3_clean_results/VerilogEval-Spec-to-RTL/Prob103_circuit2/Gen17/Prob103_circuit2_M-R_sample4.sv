// Refactored TopModule: Implementing the same logic within an always block
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Using an always block for a combinational logic description
    always @(*) begin
        // Directly computing q within the always block
        // First, compute the XOR of a and b
        logic ab_xor;
        ab_xor = a ^ b;
        
        // Then, compute the XOR of c and d
        logic cd_xor;
        cd_xor = c ^ d;
        
        // Finally, assign q as the inverse of the XOR of ab_xor and cd_xor
        q = ~(ab_xor ^ cd_xor);
    end

    // Note: The synthesis tool should optimize this always block
    // into a combinational circuit, equivalent to the original assign statements.

endmodule