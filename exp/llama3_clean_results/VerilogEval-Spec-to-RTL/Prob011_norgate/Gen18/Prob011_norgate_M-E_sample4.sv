// Novel implementation of the TopModule using a lookup table (LUT) for the NOR gate.
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);

// Define the lookup table for the NOR gate.
logic [1:0] lut_address;  // Address for the LUT, derived from inputs a and b.
logic lut_out;  // Output of the LUT.

// Combine inputs a and b to form the address for the LUT.
assign lut_address = {a, b};

// Define the LUT contents for the NOR gate.
always @(*) begin
    case(lut_address)
        2'b00: lut_out = 1'b1;  // (a, b) = (0, 0), out = 1.
        2'b01: lut_out = 1'b0;  // (a, b) = (0, 1), out = 0.
        2'b10: lut_out = 1'b0;  // (a, b) = (1, 0), out = 0.
        2'b11: lut_out = 1'b0;  // (a, b) = (1, 1), out = 0.
        default: lut_out = 1'bx;  // Invalid input combination, out = unknown.
    endcase
end

// Assign the LUT output to the module's output.
assign out = lut_out;

endmodule