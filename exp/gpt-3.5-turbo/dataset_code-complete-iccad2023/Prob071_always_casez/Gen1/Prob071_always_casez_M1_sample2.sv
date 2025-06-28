module PriorityEncoder (
  input [7:0] in,
  output reg [2:0] pos
);

always @* begin
  pos = 3'b0; // Default output
  pos = $ffs(in) - 1; // Find position of first 1 bit in input vector
end

endmodule