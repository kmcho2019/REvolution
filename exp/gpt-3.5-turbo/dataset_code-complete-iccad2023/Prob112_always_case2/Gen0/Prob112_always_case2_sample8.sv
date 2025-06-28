module PriorityEncoder4bit (
  input [3:0] in,
  output reg [1:0] pos
);
  
  always @* begin
    pos = 2'b00; // Initialize output to 00
  
    // Iterate through the input bits from MSB to LSB
    for (int i = 3; i >= 0; i = i - 1) begin
      if (in[i] == 1) begin
        pos = {i, 2'b00}; // Set output to the position of the first '1' bit
        break; // Exit the loop once a '1' bit is found
      end
    end
  end

endmodule