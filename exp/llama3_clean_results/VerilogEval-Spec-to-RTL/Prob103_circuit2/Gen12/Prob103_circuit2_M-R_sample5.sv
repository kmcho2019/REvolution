// Refactored TopModule using an always block
module TopModule_always(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    always @(*) begin
        // Compute the XOR of inputs a, b, c, and d within the always block
        q = ~(a ^ b ^ c ^ d);
    end

endmodule

// Refactored TopModule breaking down the XOR operation into steps
module TopModule_stepwise(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    logic ab_xor, abc_xor;  // Intermediate variables for XOR operations

    assign ab_xor = a ^ b;  // XOR of a and b
    assign abc_xor = ab_xor ^ c;  // XOR of (a^b) and c
    assign q = ~(abc_xor ^ d);  // Final NOT operation on the full XOR

endmodule