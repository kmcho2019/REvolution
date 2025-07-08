module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);
  reg [511:0] next_q;

  integer i;
  always @* begin
    for (i = 0; i < 512; i = i + 1) begin
      // Determine neighbors with boundaries treated as 0
      // left = q[i+1], center = q[i], right = q[i-1]
      // if out of bounds, use 0
      wire left  = (i == 511) ? 1'b0 : q[i+1];
      wire center= q[i];
      wire right = (i == 0)   ? 1'b0 : q[i-1];
      // According to the rule:
      // next state = (~left & center & right) | (center & ~right) | (left & ~center & right);
      // or equivalently:
      next_q[i] = (left & center & right) ? 1'b0 :
                  (left & center & ~right) ? 1'b1 :
                  (left & ~center & right) ? 1'b1 :
                  (left & ~center & ~right)? 1'b0 :
                  (~left & center & right) ? 1'b1 :
                  (~left & center & ~right)? 1'b1 :
                  (~left & ~center & right)? 1'b1 :
                  1'b0;
    end
  end

  always @(posedge clk) begin
    if (load)
      q <= data;
    else
      q <= next_q;
  end

endmodule