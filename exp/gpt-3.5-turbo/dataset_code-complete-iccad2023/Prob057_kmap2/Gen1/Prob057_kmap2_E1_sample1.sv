module TopModule (
  input [3:0] address,
  output out
);
  
reg [15:0] lut;  // 4-bit address corresponds to a 16-entry LUT

always @* begin
    case(address)
        4'b0000: lut = 1'b1;  // Corresponds to cell 00
        4'b0001: lut = 1'b1;  // Corresponds to cell 01
        4'b0010: lut = 1'b0;  // Corresponds to cell 11
        4'b0011: lut = 1'b1;  // Corresponds to cell 10
        4'b0100: lut = 1'b1;  // Corresponds to cell 00
        4'b0101: lut = 1'b0;  // Corresponds to cell 01
        4'b0110: lut = 1'b0;  // Corresponds to cell 11
        4'b0111: lut = 1'b1;  // Corresponds to cell 10
        4'b1000: lut = 1'b0;  // Corresponds to cell 00
        4'b1001: lut = 1'b1;  // Corresponds to cell 01
        4'b1010: lut = 1'b1;  // Corresponds to cell 11
        4'b1011: lut = 1'b1;  // Corresponds to cell 10
        4'b1100: lut = 1'b1;  // Corresponds to cell 00
        4'b1101: lut = 1'b1;  // Corresponds to cell 01
        4'b1110: lut = 1'b0;  // Corresponds to cell 11
        4'b1111: lut = 1'b0;  // Corresponds to cell 10
    endcase
end

assign out = lut;

endmodule