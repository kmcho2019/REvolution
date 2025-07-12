module TopModule(input a, b, sel, output out);
  assign out = sel ? b : a;
endmodule