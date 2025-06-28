module TopModule (
  input [7:0] in,
  output reg [2:0] pos
);

always @* begin
  // Default output value
  pos = 3'b0;
  
  // Use bitwise AND operation with inverted input to find rightmost high bit
  pos = |(in & ((1 << 8) - 1));
end

endmodule