module TopModule (
  input [7:0] in,
  output reg [2:0] pos
);

always @(*) begin
  pos = 3'd0; // Default value if no 1 is found
  if (in != 8'b00000000) begin
    pos = $clog2(in & -in) - 1; // Find the position of the rightmost high bit
  end
end

endmodule