module ConstZero(output out);
  // Always drives logic zero
  assign out = 1'b0;
endmodule

module TopModule(output out);
  // Instantiate the constant zero generator
  ConstZero cz(.out(out));
endmodule