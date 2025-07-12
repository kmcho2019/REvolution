// Module TopModule implements an XNOR gate using a lookup table (LUT)
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Define the LUT for the XNOR operation
reg [1:0] lut_out;
always @(*) begin
    case({a, b})
        2'b00: lut_out = 1'b1; // a=0, b=0 -> out=1
        2'b01: lut_out = 1'b0; // a=0, b=1 -> out=0
        2'b10: lut_out = 1'b0; // a=1, b=0 -> out=0
        2'b11: lut_out = 1'b1; // a=1, b=1 -> out=1
        default: lut_out = 1'bx; // Invalid input combination
    endcase
end

// Assign the output from the LUT
assign out = lut_out;

endmodule