module TopModule (
  input [7:0] in,
  output reg [2:0] pos
);

always @* begin
  pos = 3'd0; // Default value if no 1 is found
  casez(in) // Detect the first high bit in the input vector
    8'b1??????? : pos = 3'd0; // Bit 0 is high
    8'b01?????? : pos = 3'd1; // Bit 1 is high
    8'b001????? : pos = 3'd2; // Bit 2 is high
    8'b0001???? : pos = 3'd3; // Bit 3 is high
    8'b00001??? : pos = 3'd4; // Bit 4 is high
    8'b000001?? : pos = 3'd5; // Bit 5 is high
    8'b0000001? : pos = 3'd6; // Bit 6 is high
    8'b00000001 : pos = 3'd7; // Bit 7 is high
    default: pos = 3'd0; // No bits are high
  endcase
end

endmodule