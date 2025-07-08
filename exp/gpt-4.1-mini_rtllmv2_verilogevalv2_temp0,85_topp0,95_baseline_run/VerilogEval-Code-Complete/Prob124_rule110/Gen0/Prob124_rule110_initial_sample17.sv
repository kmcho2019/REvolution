module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);
  reg [511:0] next;

  integer i;
  always @* begin
    for (i = 0; i < 512; i = i + 1) begin
      // Determine neighbors with boundary condition zero
      wire left = (i < 511) ? q[i+1] : 1'b0;
      wire center = q[i];
      wire right = (i > 0) ? q[i-1] : 1'b0;

      // Apply Rule 110 logic
      // next = left & center & right ? 0
      //      : left & center & ~right ? 1
      //      : left & ~center & right ? 1
      //      : left & ~center & ~right ? 0
      //      : ~left & center & right ? 1
      //      : ~left & center & ~right ? 1
      //      : ~left & ~center & right ? 1
      //      : 0;
      // Simplify: next = (left & center & right) ? 0 : ...
      // Or implement as direct expression:

      next[i] = (left & center & right) ? 1'b0 :
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
    if (load) begin
      q <= data;
    end else begin
      q <= next;
    end
  end
endmodule