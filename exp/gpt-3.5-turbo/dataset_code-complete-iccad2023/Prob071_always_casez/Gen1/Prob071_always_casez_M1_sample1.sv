module PriorityEncoder (
  input [7:0] in,
  output reg [2:0] pos
);

always @* begin
  pos = 3'b0;
  pos = $ffs(in) - 1; // $ffs returns the position of the first set bit in the input
end

endmodule