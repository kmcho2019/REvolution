module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);
  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      // Left neighbors: q shifted right by 1, leftmost bit zero
      // Right neighbors: q shifted left by 1, rightmost bit zero
      q <= ({q[510:0], 1'b0}) ^ ({1'b0, q[511:1]});
    end
  end
endmodule