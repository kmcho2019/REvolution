module PriorityEncoder4bit (
  input [3:0] in,
  output reg [1:0] pos
);

  always @* begin
    // Generate a mask with the position of the first high bit
    // Using bitwise OR operations and bitwise inversion
    // High bit at position n -> mask = (2^n-1) + 1
    // Example: 8'b10010000 -> mask = 8'b00001111 + 1 = 8'b00010000
    pos = (in | ~in << 1 | ~in << 2 | ~in << 3) + 1;
  end

endmodule