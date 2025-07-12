module TopModule(
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

reg [1:0] lut_out;

// Define the lookup table
always @(*) begin
    case ({a, b, cin})
        3'b000: lut_out = 2'b00;
        3'b001: lut_out = 2'b01;
        3'b010: lut_out = 2'b01;
        3'b011: lut_out = 2'b10;
        3'b100: lut_out = 2'b01;
        3'b101: lut_out = 2'b10;
        3'b110: lut_out = 2'b10;
        3'b111: lut_out = 2'b11;
        default: lut_out = 2'b00;
    endcase
end

// Assign the LUT output to sum and cout
assign sum  = lut_out[0];
assign cout = lut_out[1];

endmodule