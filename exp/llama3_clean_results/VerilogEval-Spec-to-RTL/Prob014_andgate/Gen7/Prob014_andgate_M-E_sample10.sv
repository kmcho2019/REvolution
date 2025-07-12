// TopModule: A 2-input AND gate implemented using a lookup table.
module TopModule(
    input  a,  // First input of the AND gate.
    input  b,  // Second input of the AND gate.
    output reg out  // Output of the AND gate.
);

// Define the lookup table for the AND gate.
// The table maps input combinations to output values.
// For an AND gate, the output is 1 only when both inputs are 1.
always @(*) begin
    case ({a, b})  // Use the concatenation of a and b as the case expression.
        2'b00: out = 1'b0;  // Both inputs are 0, output is 0.
        2'b01: out = 1'b0;  // Input a is 0, input b is 1, output is 0.
        2'b10: out = 1'b0;  // Input a is 1, input b is 0, output is 0.
        2'b11: out = 1'b1;  // Both inputs are 1, output is 1.
        default: out = 1'b0;  // Default case, output is 0.
    endcase
end

endmodule