module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);
  integer i;
  reg [511:0] next_q;

  always @(*) begin
    for (i = 0; i < 512; i = i + 1) begin
      // Left neighbor, zero if i=0
      wire left = (i == 0) ? 1'b0 : q[i-1];
      // Right neighbor, zero if i=511
      wire right = (i == 511) ? 1'b0 : q[i+1];
      next_q[i] = left ^ right;
    end
  end

  always @(posedge clk) begin
    if (load)
      q <= data;
    else
      q <= next_q;
  end
endmodule