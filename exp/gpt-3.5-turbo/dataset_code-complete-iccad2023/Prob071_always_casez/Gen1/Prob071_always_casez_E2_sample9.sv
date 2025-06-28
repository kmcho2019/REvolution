module TopModule (
  input [7:0] in,
  output reg [2:0] pos
);

always @* begin
  pos = 3'b0; // Default output value

  // Initialize a positional counter
  int i = 0;
  
  // Iterate through the input bits
  while (i < 8) begin
    // Check if the LSB of the input vector is high
    if (in[0] == 1'b1) begin
      // Assign the position of the high bit to the output
      pos = i;
      break; // Exit the loop if a high bit is found
    end
    
    // Shift the input vector to the right by one bit
    in = in >> 1;
    i = i + 1; // Increment the positional counter
  end
end

endmodule