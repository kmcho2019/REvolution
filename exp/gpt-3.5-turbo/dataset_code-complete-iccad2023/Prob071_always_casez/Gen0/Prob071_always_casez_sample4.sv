module TopModule (
  input [7:0] in,
  output reg [2:0] pos
);

always @(*) begin
  pos = 3'b0; // Initialize output position to 0
  for (int i = 0; i < 8; i = i + 1) begin
    if (in[i] == 1) begin
      pos = i; // Set output position to the index of the high bit
      break; // Exit loop early once a high bit is found
    end
  end
end

endmodule