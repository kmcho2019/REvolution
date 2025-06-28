module TopModule (
  input [7:0] in,
  output reg [2:0] pos
);

always @(*) begin
  pos = 3'd0; // Default value if no 1 is found
  pos = $ffs(in) - 1; // Using the $ffs system function to find the first set bit position
end

endmodule