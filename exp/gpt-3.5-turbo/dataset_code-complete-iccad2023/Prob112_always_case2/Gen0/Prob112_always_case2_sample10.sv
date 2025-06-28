module TopModule (
  input [3:0] in,
  output reg [1:0] pos
);

always @(*) begin
  pos = 2'b00; // Default output
  for (int i = 0; i < 4; i = i + 1) begin
    if (in[i] == 1'b1) begin
      pos = i; // Position of the first high bit
      break; // Exit the loop once the first high bit is found
    end
  end
end

endmodule