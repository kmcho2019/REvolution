module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);
  reg [511:0] next_q;

  integer i;
  always @(*) begin
    // For boundary cells, neighbors out of range assumed 0
    for (i = 0; i < 512; i = i + 1) begin
      // left neighbor
      wire left = (i == 0) ? 1'b0 : q[i-1];
      // right neighbor
      wire right = (i == 511) ? 1'b0 : q[i+1];
      next_q[i] = left ^ right;
    end
  end

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      q <= next_q;
    end
  end
endmodule