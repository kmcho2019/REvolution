module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

reg a_prev;

always @ (posedge clk) begin
  if (a && !a_prev) begin
    if (q < 3'd6)
      q <= q + 1;
  end else if (!a) begin
    q <= 3'b0;
  end
  a_prev <= a;
end

endmodule