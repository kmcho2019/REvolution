module PriorityEncoder4bit (
  input [3:0] in,
  output reg [1:0] pos
);

  always @* begin
    pos = 2'b00; // Initialize output to zero (position 0)
    
    if(in[3] == 1'b1)
      pos = 2'b11; // Highest priority bit at position 3
    else if(in[2] == 1'b1)
      pos = 2'b10; // Second highest priority bit at position 2
    else if(in[1] == 1'b1)
      pos = 2'b01; // Third highest priority bit at position 1
    else if(in[0] == 1'b1)
      pos = 2'b00; // Lowest priority bit at position 0
  end

endmodule