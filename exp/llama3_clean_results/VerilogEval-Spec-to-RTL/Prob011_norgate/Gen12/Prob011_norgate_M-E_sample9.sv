// Module TopModule implements a NOR gate using a case statement to directly define the truth table.
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);

// Implement the NOR operation using a case statement to define the truth table explicitly.
always @(*) begin
    case({a, b})  // Combine inputs a and b into a single bit vector for case statement
        2'b00: out = 1'b1;  // If both a and b are 0, out is 1 (NOR operation)
        2'b01, 2'b10, 2'b11: out = 1'b0;  // For any other combination, out is 0
    endcase
end

// This implementation provides a straightforward, truth-table-based approach to designing the NOR gate.
endmodule