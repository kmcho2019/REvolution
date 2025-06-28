module TopModule (
  input clk,
  input w,
  input R,
  input E,
  input L,
  output reg Q
);

reg Q_next;

always @(posedge clk) begin
  if (L) begin
    Q_next <= R;
  end
  else if (E) begin
    Q_next <= {Q, w};
  end
  else begin
    Q_next <= Q;
  end
end

always @(posedge clk) begin
  Q <= Q_next;
end

endmodule