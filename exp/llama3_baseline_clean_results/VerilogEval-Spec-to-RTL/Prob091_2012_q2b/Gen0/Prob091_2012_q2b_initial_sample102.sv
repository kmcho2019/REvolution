module TopModule(
  input [5:0] y,
  input w,
  output Y1,
  output Y3
);

assign Y1 = (y[0] && w); // A (0) --1--> B
assign Y3 = ((y[1] && ~w) || (y[2] && ~w) || (y[4] && ~w)); // B, C, E --0--> D

endmodule