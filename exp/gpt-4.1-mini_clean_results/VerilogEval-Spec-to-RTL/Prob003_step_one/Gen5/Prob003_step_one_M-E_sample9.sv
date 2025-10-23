module ConstHigh(output out);
  // Always drive output high using continuous assignment
  assign out = 1'b1;
endmodule

module TopModule(output one);
  // Instantiate ConstHigh module to provide constant '1'
  ConstHigh ch(.out(one));
endmodule