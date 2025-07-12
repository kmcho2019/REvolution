// TopModule: A combinational circuit implementing the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Use an always block with combinational logic and a sensitivity list
    always @(*) begin
        // The output q is the inverse of the XOR of all input bits
        q = ~(a ^ b ^ c ^ d);  // Use XOR operator (^) followed by NOT operator (~)
    end

endmodule