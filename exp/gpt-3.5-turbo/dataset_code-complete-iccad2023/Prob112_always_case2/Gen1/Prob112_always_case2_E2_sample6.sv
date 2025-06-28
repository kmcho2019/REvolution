module PriorityEncoder4bit (
  input [3:0] in,
  output reg [1:0] pos
);

  always @* begin
    if (in == 4'b0000) // If all input bits are low
      pos = 2'b00; // Output remains zero
    else
      pos = 2'b11 - (&~in); // Invert bits and bitwise-AND to find highest priority bit position
  end

endmodule