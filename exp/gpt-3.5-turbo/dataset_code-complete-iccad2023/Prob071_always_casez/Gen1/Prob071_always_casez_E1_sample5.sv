module TopModule (
  input [7:0] in,
  output reg [2:0] pos
);

always @(in) begin
  pos = 3'd0; // Initialize position to 0
  reg [7:0] invert_in;

  invert_in = ~in; // Get the two's complement of the input

  // Perform a bitwise OR operation to isolate the least significant 1 bit
  invert_in = in | invert_in;

  // Count the number of leading zeros to determine the position of the first high bit
  for (int i = 0; i < 8; i = i + 1) begin
    if (invert_in[i] == 1) begin
      pos = i + 1;
      break;
    end
  end
end

endmodule