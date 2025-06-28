module PriorityEncoder4bit (
  input [3:0] in,
  output reg [1:0] pos
);
  
  always @* begin
    pos = 2'b00; // Initialize output
    
    for (int i = 0; i < 4; i = i + 1) begin
      if (in[i] == 1'b1) begin
        pos = i; // Update position if high bit is found
        break; // Exit loop immediately after updating position
      end
    end
  end

endmodule