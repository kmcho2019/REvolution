module TopModule (
  input clk,
  input w,
  input R,
  input E,
  input L,
  output reg Q
);

  reg D;

  always @ (posedge clk) begin
    if (L) begin
      D <= R;
    end else if (E) begin
      D <= Q;
    end
  end

  assign Q = (E) ? (L ? R : D) : w;

endmodule