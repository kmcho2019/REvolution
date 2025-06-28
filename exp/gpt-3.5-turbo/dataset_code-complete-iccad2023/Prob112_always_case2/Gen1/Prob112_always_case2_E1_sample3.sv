module PriorityEncoder4bit (
  input [3:0] in,
  output reg [1:0] pos
);

  always @* begin
    pos = 2'b00; // Initialize output
    
    if(in[3] == 1'b1) begin
      pos = 2'b11; // If MSB is high, set output to 3 (bit position 3)
    end else if(in[2] == 1'b1) begin
      pos = 2'b10; // If bit at position 2 is high, set output to 2
    end else if(in[1] == 1'b1) begin
      pos = 2'b01; // If bit at position 1 is high, set output to 1
    end else if(in[0] == 1'b1) begin
      pos = 2'b00; // If LSB is high, set output to 0
    end
  end

endmodule