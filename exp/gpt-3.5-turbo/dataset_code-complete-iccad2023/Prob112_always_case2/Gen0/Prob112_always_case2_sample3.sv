module TopModule (
  input [3:0] in,
  output reg [1:0] pos
);

always @(*) begin
  pos = 2'b00; // Default output is 0

  // Loop through each bit starting from MSB
  for (int i = 3; i >= 0; i=i-1) begin
    if (in[i] == 1) begin
      pos = i[1:0]; // Assign position of first high bit to output
      break; // Exit loop once first high bit is found
    end
  end
end

endmodule