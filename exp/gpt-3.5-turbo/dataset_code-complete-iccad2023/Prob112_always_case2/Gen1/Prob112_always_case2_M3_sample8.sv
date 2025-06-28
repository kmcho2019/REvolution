module PriorityEncoder4bit (
  input [3:0] in,
  output reg [1:0] pos
);
  
  always @* begin
    pos = 2'b00; // Initialize output
    
    // Use logical AND to detect first high bit
    // Use sign extension to replicate the high bit position
    pos = (in[0] & 2'b01) ? 2'b00 : (in[1] & 2'b10) ? {1'b1, 1'b0} : (in[2] & 2'b100) ? {1'b1, 1'b1} : {1'b1, 1'b1};

  end

endmodule