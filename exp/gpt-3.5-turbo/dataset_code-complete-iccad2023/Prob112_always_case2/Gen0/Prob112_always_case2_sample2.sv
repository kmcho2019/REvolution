module TopModule (
  input [3:0] in,
  output reg [1:0] pos
);

always @(*) begin
  pos = 2'b00; // Initialize output to zero by default
  for (int i = 3; i >= 0; i=i-1) begin
    if (in[i] == 1) begin
      pos = i[1:0]; // Assign position of the first high bit to output
      break;
    end
  end
end

endmodule