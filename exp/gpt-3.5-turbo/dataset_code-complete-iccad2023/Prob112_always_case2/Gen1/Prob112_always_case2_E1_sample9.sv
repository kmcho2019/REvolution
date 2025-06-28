module PriorityEncoder4bit (
  input [3:0] in,
  output reg [1:0] pos
);
  
  reg [3:0] in_twos_complement;
  
  always @* begin
    in_twos_complement = ~in + 1; // Two's complement of the input
    
    // Find the position of the first high bit using bitwise operations
    pos = 2'b00;
    if(in_twos_complement[3] == 1'b1) pos = 2'b11;
    else if(in_twos_complement[2] == 1'b1) pos = 2'b10;
    else if(in_twos_complement[1] == 1'b1) pos = 2'b01;
    else if(in_twos_complement[0] == 1'b1) pos = 2'b00;
  end

endmodule