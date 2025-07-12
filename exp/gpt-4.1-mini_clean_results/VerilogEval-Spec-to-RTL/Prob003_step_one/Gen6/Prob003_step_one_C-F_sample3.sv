module ConstValue #(parameter VAL = 1'b1) (output out);
  // Drive output with the parameterized constant value
  assign out = VAL;
endmodule

module TopModule(output one);
  // Instantiate ConstValue with default parameter VAL=1'b1 to drive 'one'
  ConstValue #(.VAL(1'b1)) constHighInst (.out(one));
endmodule