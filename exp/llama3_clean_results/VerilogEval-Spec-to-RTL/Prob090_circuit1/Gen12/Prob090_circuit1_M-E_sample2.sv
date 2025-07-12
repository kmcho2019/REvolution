// Novel solution using a lookup table (LUT)
module TopModule(
    input  logic a,
    input  logic b,
    output logic q
);

// Define the LUT as a 2D array
logic [1:0] lut_addr;
logic lut_out;

// Assign the input combination to the LUT address
assign lut_addr = {a, b};

// Define the LUT contents (truth table)
always @(*) begin
    case (lut_addr)
        2'b00: lut_out = 1'b0;
        2'b01: lut_out = 1'b0;
        2'b10: lut_out = 1'b0;
        2'b11: lut_out = 1'b1;
        default: lut_out = 1'bx; // Default value for invalid inputs
    endcase
end

// Assign the LUT output to the module output
assign q = lut_out;

endmodule