// Novel Module TopModule implements an XNOR gate using a look-up table approach
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out // Output signal out
);

// Define the look-up table for the XNOR operation
always @(*) begin
    case ({a, b})
        2'b00: out = 1'b1; // Both inputs 0, output 1
        2'b01: out = 1'b0; // Inputs different, output 0
        2'b10: out = 1'b0; // Inputs different, output 0
        2'b11: out = 1'b1; // Both inputs 1, output 1
        default: out = 1'bx; // Invalid input combination, output undefined
    endcase
end

endmodule