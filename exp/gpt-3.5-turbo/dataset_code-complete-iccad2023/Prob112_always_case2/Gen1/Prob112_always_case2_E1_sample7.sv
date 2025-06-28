module PriorityEncoder4bit (
  input [3:0] in,
  output reg [1:0] pos
);
  
  always @* begin
    pos = 2'b00; // Initialize output
    
    if (in[0] == 1'b1) pos = 2'b00; // Bit[0] is high
    else if (in[1] == 1'b1) pos = 2'b01; // Bit[1] is high
    else if (in[2] == 1'b1) pos = 2'b10; // Bit[2] is high
    else if (in[3] == 1'b1) pos = 2'b11; // Bit[3] is high
  end

endmodule