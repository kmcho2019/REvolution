module TopModule (
  input [7:0] in,
  output reg [2:0] pos
);

always @* begin
  pos = 3'b0; // Default output value

  // Loop through each bit from LSB to MSB
  for (int i = 0; i<8; i=i+1) begin
    // Check if the current bit is high
    if (in[i] == 1'b1) begin
      // Update the position register with the position of the first high bit
      pos = i;
      // Exit the loop if a high bit is found
      break;
    end
  end
end

endmodule