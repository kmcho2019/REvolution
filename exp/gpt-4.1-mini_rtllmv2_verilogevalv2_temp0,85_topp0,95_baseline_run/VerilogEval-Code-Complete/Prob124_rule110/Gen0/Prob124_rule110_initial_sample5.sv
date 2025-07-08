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
      // Define neighbors with boundary = 0
      wire left = (i < 511) ? q[i+1] : 1'b0;
      wire center = q[i];
      wire right = (i > 0) ? q[i-1] : 1'b0;

      // Apply Rule 110:
      // 111 -> 0
      // 110 -> 1
      // 101 -> 1
      // 100 -> 0
      // 011 -> 1
      // 010 -> 1
      // 001 -> 1
      // 000 -> 0
      // Using the same order: (left, center, right)
      next_q[i] = (left & center & right) ? 1'b0 :
                  (left & center & ~right) ? 1'b1 :
                  (left & ~center & right) ? 1'b1 :
                  (left & ~center & ~right) ? 1'b0 :
                  (~left & center & right) ? 1'b1 :
                  (~left & center & ~right) ? 1'b1 :
                  (~left & ~center & right) ? 1'b1 :
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