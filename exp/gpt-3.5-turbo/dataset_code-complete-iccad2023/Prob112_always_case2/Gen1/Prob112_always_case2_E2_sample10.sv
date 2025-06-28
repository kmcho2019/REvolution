module PriorityEncoder4bit (
  input [3:0] in,
  output reg [1:0] pos
);
  
  always @* begin
    pos = 2'b00; // Initialize output
    
    if(in[3] == 1'b1) // Check MSB
      pos = 2'b11;
    else if(in[2] == 1'b1) // Check next bit
      pos = 2'b10;
    else if(in[1] == 1'b1) // Check next bit
      pos = 2'b01;
    else if(in[0] == 1'b1) // Check LSB
      pos = 2'b00;
  end

endmodule