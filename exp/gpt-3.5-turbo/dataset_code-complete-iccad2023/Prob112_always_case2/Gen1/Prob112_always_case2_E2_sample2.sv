module PriorityEncoder4bit (
  input [3:0] in,
  output reg [1:0] pos
);
  
  always @* begin
    pos = 2'b00; // Default output position
  
    for (int i = 0; i < 4; i = i + 1) begin
      if (in[i]) begin
        pos = i; // Set position to the first '1' bit encountered
        break; // Exit the loop once the position is set
      end
    end
  end

endmodule