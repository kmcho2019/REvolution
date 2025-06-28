module TopModule (
  input [7:0] in,
  output reg [2:0] pos
);

always @(*) begin
  pos = 3'b0; // Initialize output to 0
  bit found_high_bit = 1'b0; // Flag to track if a high bit is found

  for (int i = 0; i < 8; i=i+1) begin
    if (in[i] == 1'b1 && !found_high_bit) begin
      pos = i; // Update position with the first high bit found
      found_high_bit = 1'b1; // Set flag to indicate a high bit is found
    end
  end
end

endmodule