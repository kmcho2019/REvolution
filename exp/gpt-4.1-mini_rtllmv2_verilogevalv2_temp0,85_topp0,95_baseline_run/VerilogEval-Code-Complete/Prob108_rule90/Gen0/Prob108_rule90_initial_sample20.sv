module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);
  reg [511:0] q_next;

  always @(*) begin
    integer i;
    // Compute next state q_next based on Rule 90
    for (i = 0; i < 512; i = i + 1) begin
      // left neighbor, zero if i == 0
      wire left = (i == 0) ? 1'b0 : q[i-1];
      // right neighbor, zero if i == 511
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