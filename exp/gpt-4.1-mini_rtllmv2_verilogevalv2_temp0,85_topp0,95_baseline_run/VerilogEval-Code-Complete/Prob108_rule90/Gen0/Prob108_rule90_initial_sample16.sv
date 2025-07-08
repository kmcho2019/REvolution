module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);
  reg [511:0] q_next;

  integer i;
  always @(*) begin
    // Compute next state
    for (i = 0; i < 512; i = i + 1) begin
      // Left neighbor: q[i-1], zero if i == 0
      wire left = (i == 0) ? 1'b0 : q[i-1];
      // Right neighbor: q[i+1], zero if i == 511
      wire right = (i == 511) ? 1'b0 : q[i+1];
      q_next[i] = left ^ right;
    end
  end

  always @(posedge clk) begin
    if (load)
      q <= data;
    else
      q <= q_next;
  end
endmodule