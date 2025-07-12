module ConstLogic #(parameter VALUE = 1'b1) (output out);
  // Output is driven by the parameter VALUE, allowing configurability
  assign out = VALUE;
endmodule

module TopModule(output one);
  // Instantiate ConstLogic with parameter set to 1 (logic high)
  ConstLogic #(.VALUE(1'b1)) const_inst(.out(one));
endmodule