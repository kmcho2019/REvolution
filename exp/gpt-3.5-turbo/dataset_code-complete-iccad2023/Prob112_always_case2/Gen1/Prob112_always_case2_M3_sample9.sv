module PriorityEncoder4bit (
  input [3:0] in,
  output reg [1:0] pos
);
  
  always @* begin
    // Initialize output
    pos = 2'b00;
    
    // Using bitwise AND operator to find the first high bit position
    pos = (in[0] == 1'b1) ? 2'b00 : ((in[1] == 1'b1) ? 2'b01 : ((in[2] == 1'b1) ? 2'b10 : ((in[3] == 1'b1) ? 2'b11 : 2'b00)));
  end

endmodule