module ModuleA (
  input x,
  input y,
  output z
);

  assign z = (x ^ y) & x;

endmodule

module ModuleB (
  input x,
  input y,
  output z
);

  assign z = 0;

  initial begin
    #25 z = (x == 1'b1) ? 0 : 1;
    #40 z = (y == 1'b1) ? 0 : 1;
    #45 z = (x == 1'b1 && y == 1'b1) ? 1 : 0;
    #55 z = (x == 1'b0 && y == 1'b0) ? 1 : 0;
    #70 z = (x == 1'b1 && y == 1'b1) ? 1 : 0;
    #75 z = (y == 1'b1) ? 0 : 1;
    #85 z = (y == 1'b1) ? 0 : 1;
  end

endmodule

module TopModule (
  input x,
  input y,
  output z
);

  wire a_out_1, a_out_2, b_out_1, b_out_2, or_out, and_out;

  ModuleA A1(x, y, a_out_1);
  ModuleA A2(x, y, a_out_2);

  ModuleB B1(x, y, b_out_1);
  ModuleB B2(x, y, b_out_2);

  assign or_out = a_out_1 | b_out_1;
  assign and_out = a_out_2 & b_out_2;

  assign z = or_out ^ and_out;

endmodule