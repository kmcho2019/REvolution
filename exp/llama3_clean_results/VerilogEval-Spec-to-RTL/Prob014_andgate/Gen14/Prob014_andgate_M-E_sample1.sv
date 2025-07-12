// TopModule: An alternative implementation of a 2-input AND gate
module TopModule(
    input  logic a,  // First input of the AND gate
    input  logic b,  // Second input of the AND gate
    output logic out // Output of the AND gate
);

// Use a case statement within an always @(*) block
always @(*) begin
    case ({a, b})
        2'b00: out = 1'b0; // If both a and b are 0, out is 0
        2'b01: out = 1'b0; // If a is 0 and b is 1, out is 0
        2'b10: out = 1'b0; // If a is 1 and b is 0, out is 0
        2'b11: out = 1'b1; // If both a and b are 1, out is 1
        default: out = 1'bx; // Default case for unknown inputs
    endcase
end

endmodule