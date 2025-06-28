module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

always @ (posedge clk) begin
  if (a == 1 && $past(a) == 1) begin
    q <= q;
  end
  else if (a == 0 && $past(a) == 1) begin
    if (q == 6)
      q <= 0;
    else
      q <= q + 1;
  end
  else begin
    q <= q;
  end
end

endmodule