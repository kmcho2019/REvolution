module PriorityEncoder4bit (
  input [3:0] in,
  output reg [1:0] pos
);
  
  always @* begin
    pos = 2'b00; // Initialize output
    
    pos = (in[3] << 1) | (in[2] << 0) | (in[1] << 1) | (in[0] << 0);
    
  end

endmodule