module TopModule (
  input [7:0] in,
  output reg [2:0] pos
);

always @(*) begin
  pos = 3'd0; // Default value if no 1 is found
  case(in)
    8'b00000001: pos = 3'd0; // Bit 0 has highest priority
    8'b00000010: pos = 3'd1; // Bit 1 has highest priority
    8'b00000100: pos = 3'd2; // Bit 2 has highest priority
    8'b00001000: pos = 3'd3; // Bit 3 has highest priority
    8'b00010000: pos = 3'd4; // Bit 4 has highest priority
    8'b00100000: pos = 3'd5; // Bit 5 has highest priority
    8'b01000000: pos = 3'd6; // Bit 6 has highest priority
    8'b10000000: pos = 3'd7; // Bit 7 has highest priority
    default: pos = 3'd0; // Default value if no 1 is found
  endcase
end

endmodule