module ConstantZero(output wire out);
  assign out = 1'b0;
endmodule

module TopModule(output wire zero);
  ConstantZero cz(.out(zero));
endmodule