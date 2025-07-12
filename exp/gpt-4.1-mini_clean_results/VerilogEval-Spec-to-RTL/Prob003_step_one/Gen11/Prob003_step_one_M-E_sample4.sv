module ConstOne(output out);
  assign out = 1'b1;
endmodule

module TopModule(output one);
  ConstOne const_inst(.out(one));
endmodule