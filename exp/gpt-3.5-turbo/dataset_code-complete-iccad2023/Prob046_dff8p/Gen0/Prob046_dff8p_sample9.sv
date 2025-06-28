module TopModule (
  input clk,
  input [7:0] d,
  input reset,
  output reg [7:0] q
);

reg [7:0] q_reg [0:7];

always @(negedge clk) begin
  if (reset) begin
    for (int i=0; i<8; i=i+1) begin
      q_reg[i] <= 8'h34;
    end
  end
  else begin
    for (int i=0; i<8; i=i+1) begin
      q_reg[i] <= d[i];
    end
  end
end

always @(posedge clk) begin
  for (int i=0; i<8; i=i+1) begin
    q[i] <= q_reg[i];
  end
end

endmodule