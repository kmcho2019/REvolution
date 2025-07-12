module ConstantZero(output out);
  assign out = 1'b0;
endmodule

module TopModule(output out);
  ConstantZero cz_inst(.out(out));
endmodule