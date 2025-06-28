module TopModule (
  input clk,
  input [7:0] d,
  input reset,
  output reg [7:0] q
);

reg [7:0] q_reg [7:0]; // Array of 8 8-bit registers

always @ (negedge clk) begin
  if (reset) begin
    for (int i = 0; i < 8; i=i+1) begin
      q_reg[i] <= 8'b00110100; // Load 0x34
    end
  end else begin
    for (int i = 0; i < 8; i=i+1) begin
      q_reg[i] <= d[i]; // Load input data
    end
  end
end

always @* begin
  for (int i = 0; i < 8; i=i+1) begin
    q[i] = q_reg[i]; // Output stored values
  end
end

endmodule