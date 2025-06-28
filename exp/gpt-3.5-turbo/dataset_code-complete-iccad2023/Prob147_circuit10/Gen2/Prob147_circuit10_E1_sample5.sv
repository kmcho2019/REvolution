module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

always @(posedge clk) begin
  if (a == 1'b1) begin
    q <= ~q;
    state <= 1'b0;
  end
  else begin
    if (b == 1'b1) begin
      state <= 1'b1;
      q <= 1'b1;
    end
    else begin
      q <= q;
      state <= 1'b0;
    end
  end
end

endmodule