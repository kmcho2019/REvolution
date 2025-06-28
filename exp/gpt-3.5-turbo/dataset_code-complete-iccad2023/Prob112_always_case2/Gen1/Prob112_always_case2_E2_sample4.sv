module PriorityEncoder4bit (
  input [3:0] in,
  output reg [1:0] pos
);

  integer i;
  reg found;
  
  always @* begin
    pos = 2'b00; // Initialize output
    found = 1'b0; // Set flag to false
    
    for(i = 0; i < 4; i = i + 1) begin
      if(in[i] == 1'b1 && !found) begin
        pos = i; // Set position to the bit index
        found = 1'b1; // Set flag to true to exit loop
      end
    end
  end

endmodule