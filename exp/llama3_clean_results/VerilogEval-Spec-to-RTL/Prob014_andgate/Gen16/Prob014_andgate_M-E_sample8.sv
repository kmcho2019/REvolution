// TopModule: A 2-input AND gate implemented using a lookup table
module TopModule(
    input  logic a,  // First input of the AND gate
    input  logic b,  // Second input of the AND gate
    output logic out // Output of the AND gate
);

// Define the lookup table for the AND gate
// The LUT is essentially the truth table of the AND gate
always @(*) begin
    case ({a, b})
        2'b00: out = 1'b0; // If both inputs are 0, output is 0
        2'b01: out = 1'b0; // If a is 0 and b is 1, output is 0
        2'b10: out = 1'b0; // If a is 1 and b is 0, output is 0
        2'b11: out = 1'b1; // If both inputs are 1, output is 1
        default: out = 1'bx; // For any other input, output is undefined (this case should not occur)
    endcase
end

endmodule