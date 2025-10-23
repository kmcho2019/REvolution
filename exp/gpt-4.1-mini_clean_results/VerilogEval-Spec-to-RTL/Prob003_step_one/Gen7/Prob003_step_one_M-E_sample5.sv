module ConstValue #(parameter VALUE = 1'b0) (output wire out);
  // Assign the constant parameter value to the output
  assign out = VALUE;
endmodule

module TopModule(output one);
  // Instantiate ConstValue with VALUE=1 to produce a constant logic high
  ConstValue #(1'b1) const_inst (.out(one));
endmodule