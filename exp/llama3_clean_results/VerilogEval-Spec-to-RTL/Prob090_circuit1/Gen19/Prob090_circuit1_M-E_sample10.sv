// TopModule: A combinational circuit implementing a logical AND operation
// Inputs: 
//   - a: The first input to the AND operation
//   - b: The second input to the AND operation
// Outputs: 
//   - q: The result of the AND operation on inputs a and b
module TopModule(
    // Input signals
    input  logic a, // First input to the AND operation
    input  logic b, // Second input to the AND operation
    // Output signal
    output logic q  // Result of the AND operation
);

// Use an always block with a case statement to implement the AND operation
always @(*) begin
    case ({a, b})
        2'b00: q = 1'b0; // When both a and b are 0, q is 0
        2'b01: q = 1'b0; // When a is 0 and b is 1, q is 0
        2'b10: q = 1'b0; // When a is 1 and b is 0, q is 0
        2'b11: q = 1'b1; // When both a and b are 1, q is 1
        default: q = 1'bx; // For any other case (which should not occur), q is undefined
    endcase
end

endmodule