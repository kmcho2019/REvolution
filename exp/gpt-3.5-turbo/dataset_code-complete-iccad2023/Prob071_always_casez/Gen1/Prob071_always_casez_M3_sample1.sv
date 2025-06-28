module PriorityEncoder (
  input [7:0] in,
  output reg [2:0] pos
);

always @(*) begin
  case(in)
    8'b00000001: pos = 3'd0; // Position 0
    8'b00000010: pos = 3'd1; // Position 1
    8'b00000100: pos = 3'd2; // Position 2
    8'b00001000: pos = 3'd3; // Position 3
    8'b00010000: pos = 3'd4; // Position 4
    8'b00100000: pos = 3'd5; // Position 5
    8'b01000000: pos = 3'd6; // Position 6
    8'b10000000: pos = 3'd7; // Position 7
    default: pos = 3'd0; // If no bit is high, output 0
  endcase
end

endmodule