module TopModule (
  input [7:0] in,
  output reg [2:0] pos
);

always @* begin
  pos = 3'b0; // Initialize output to 0

  // Use a loop to check the position of the first high bit starting from MSB
  for (int i = 7; i >= 0; i = i - 1) begin
    if (in[i] == 1) begin
      pos = i; // Report the position of the first high bit
      break; // Stop the loop when the first high bit is found
    end
  end
end

endmodule