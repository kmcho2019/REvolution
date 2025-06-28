module TopModule (
  input clk,
  input w,
  input R,
  input E,
  input L,
  output reg Q
);

  reg data;

  always @(posedge clk) begin
    if (L) begin
      data <= R;
    end else if (E) begin
      data <= w;
    end
  end

  assign Q = data;

endmodule