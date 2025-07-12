// Module TopModule implements an XNOR gate using a lookup table (LUT)
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Define the LUT for XNOR operation
reg [1:0] lut_input;
always @(*) begin
    lut_input = {a, b};
    case(lut_input)
        2'b00: out = 1'b1;
        2'b01: out = 1'b0;
        2'b10: out = 1'b0;
        2'b11: out = 1'b1;
        default: out = 1'bx; // Default case for invalid inputs
    endcase
end

endmodule