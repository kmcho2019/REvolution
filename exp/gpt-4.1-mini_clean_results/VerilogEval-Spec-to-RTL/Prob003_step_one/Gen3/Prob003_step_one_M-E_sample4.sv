module ConstOne(output wire out);
  assign out = 1'b1;
endmodule

module TopModule(output wire one);
  ConstOne const_inst(.out(one));
endmodule