module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Define a lookup table (LUT) for the output values
reg [1:0] addr;
reg [0:0] lut_out;

always @(*) begin
    // Combine the input bits to form an address for the LUT
    addr = {x3, x2};
    case (addr)
        2'b00: lut_out = x1 ? 1'b0 : 1'b0; // x3=0, x2=0
        2'b01: lut_out = 1'b1; // x3=0, x2=1
        2'b10: lut_out = x1 ? 1'b1 : 1'b0; // x3=1, x2=0
        2'b11: lut_out = x1 ? 1'b1 : 1'b0; // x3=1, x2=1
    endcase
    // Assign the LUT output to the module output
    f = lut_out;
end

endmodule