module TopModule (
  input [7:0] in,
  output reg [2:0] pos
);

always @(*) begin
  pos = ~(&in) + 1;  // Invert the input bits, bitwise AND operation, then add 1
end

endmodule