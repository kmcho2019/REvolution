module TopModule(input wire in, output wire out);
  assign out = (1'b1) ? in : 1'b0;
endmodule