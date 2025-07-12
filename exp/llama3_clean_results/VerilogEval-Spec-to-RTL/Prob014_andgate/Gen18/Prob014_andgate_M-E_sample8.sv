// Module: TopModule
// Description: The top-level module implementing a 2-input AND gate using a lookup table.
module TopModule(
    input  logic a,  // First input of the AND gate
    input  logic b,  // Second input of the AND gate
    output logic out  // Output of the AND gate
);

// Define the lookup table for the AND gate
logic [1:0] lut_input;  // Input to the LUT, combining 'a' and 'b'
logic lut_out;  // Output of the LUT

// Combine inputs 'a' and 'b' into a single vector for the LUT
assign lut_input = {a, b};

// Use a case statement to define the LUT
always @(*) begin
    case(lut_input)
        2'b00: lut_out = 1'b0;  // Output is 0 when both inputs are 0
        2'b01: lut_out = 1'b0;  // Output is 0 when 'a' is 0 and 'b' is 1
        2'b10: lut_out = 1'b0;  // Output is 0 when 'a' is 1 and 'b' is 0
        2'b11: lut_out = 1'b1;  // Output is 1 when both inputs are 1
        default: lut_out = 1'b0;  // Default case, though it should not occur
    endcase
end

// Assign the LUT output to the module output
assign out = lut_out;

endmodule