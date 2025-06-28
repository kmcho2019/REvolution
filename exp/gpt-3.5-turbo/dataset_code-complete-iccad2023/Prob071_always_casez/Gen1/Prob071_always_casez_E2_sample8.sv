module TopModule (
  input [7:0] in,
  output reg [2:0] pos
);

always @* begin
  // Initialize position to 0 by default
  pos = 3'b0;

  // Iterate through each bit of the input from LSB to MSB
  for (int i = 0; i < 8; i = i + 1) begin
    if (in[i] == 1'b1) begin
      pos = i + 1; // Encode the position of the first high bit
      break; // Exit the loop when the high bit is found
    end
  end
end

endmodule