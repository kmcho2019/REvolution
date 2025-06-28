module TopModule (
  input [7:0] in,
  output reg [2:0] pos
);

always @(*) begin
  // Create a temporary variable to store the result
  reg [7:0] temp;
  // Perform bitwise AND with the input and a mask vector
  temp = in & ({8{1'b1}});
  // Assign the position of the first set bit
  pos = ({3{1'b0}}, temp[2], temp[1], temp[0]);
end

endmodule