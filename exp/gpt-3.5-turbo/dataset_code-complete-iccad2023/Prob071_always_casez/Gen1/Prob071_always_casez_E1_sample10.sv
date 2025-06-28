module TopModule (
  input [7:0] in,
  output reg [2:0] pos
);

always @(*) begin
  pos = 3'd0; // Default value if no 1 is found
  if (in != 8'b00000000) begin
    pos = $clog2(in & -in) - 1; // Calculate the position of the first set bit
  end
end

endmodule