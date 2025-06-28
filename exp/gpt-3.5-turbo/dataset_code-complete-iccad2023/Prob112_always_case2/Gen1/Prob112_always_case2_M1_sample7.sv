module PriorityEncoder4bit (
  input [3:0] in,
  output reg [1:0] pos
);

  always @* begin
    pos = 2'b00; // Initialize output
    integer i;
    
    for(i=0; i<4; i=i+1) begin
      if(in >> i) begin
        pos = i; // Set position to the index of the high bit
        break; // Exit loop once position is found
      end
    end
  end

endmodule