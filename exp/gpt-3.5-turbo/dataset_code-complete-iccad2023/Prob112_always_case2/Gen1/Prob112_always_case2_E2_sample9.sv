module PriorityEncoder4bit (
  input [3:0] in,
  output reg [1:0] pos
);

  always @* begin
    pos = 2'b00; // Initialize output
    if(|in) begin // Check if any of the input bits are high
      for (int i = 0; i < 4; i = i + 1) begin
        if(in[i] == 1'b1) begin
          pos = i; // Set position to the index of the first high bit
          break; // Exit the loop if a high bit is found
        end
      end
    end
  end

endmodule