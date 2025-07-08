module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);
  reg [511:0] next_q;

  integer i;
  always @(*) begin
    for (i = 0; i < 512; i = i + 1) begin
      // left neighbor: q[i-1], or 0 if i=0
      // right neighbor: q[i+1], or 0 if i=511
      next_q[i] = ( (i == 0 ? 1'b0 : q[i-1]) ) ^ ( (i == 511 ? 1'b0 : q[i+1]) );
    end
  end

  always @(posedge clk) begin
    if (load)
      q <= data;
    else
      q <= next_q;
  end
endmodule