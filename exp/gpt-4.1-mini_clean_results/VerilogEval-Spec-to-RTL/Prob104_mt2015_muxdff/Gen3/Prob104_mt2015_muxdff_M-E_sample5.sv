module Mux2to1(
  input sel,
  input d0,
  input d1,
  output y
);
  assign y = sel ? d1 : d0;
endmodule

module DFlipFlop(
  input clk,
  input d,
  output reg q
);
  always @(posedge clk) begin
    q <= d;
  end
endmodule

module TopModule(
  input clk,
  input L,
  input q_in,
  input r_in,
  output Q
);

wire mux_out;

Mux2to1 mux (
  .sel(L),
  .d0(q_in),
  .d1(r_in),
  .y(mux_out)
);

DFlipFlop dff (
  .clk(clk),
  .d(mux_out),
  .q(Q)
);

endmodule