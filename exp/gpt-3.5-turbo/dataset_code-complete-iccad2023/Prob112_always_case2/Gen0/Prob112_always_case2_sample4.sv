module PriorityEncoder4bit (
  input [3:0] in,
  output reg [1:0] pos
);
  
  integer i;
  
  always @* begin
    pos = 2'b00; // Initialize output
    
    for(i=0; i<4; i=i+1) begin
      if(in[i] == 1'b1) begin
        pos = i; // Set position to the bit index
        break; // Exit loop once first high bit is found
      end
    end
  end

endmodule