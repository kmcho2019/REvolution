module TopModule (
  input [7:0] in,
  output reg [2:0] pos
);

always @* begin
  pos = 3'b0; // Initialize output to 0

  for (int i = 0; i < 8; i = i + 1) begin
    if (in[i] == 1) begin
      pos = i + 1; // Report the position of the first high bit
      break; // Exit the loop when the first high bit is found
    end
  end
end

endmodule