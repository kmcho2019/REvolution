module DFlipFlop (
  input clk,
  input d,
  output reg q
);
  always @(posedge clk)
    q <= d;
endmodule

module TopModule (
  input clk,
  input x,
  output reg z
);
  reg dff_output_1, dff_output_2, dff_output_3;
  reg not_dff_output_1, not_dff_output_2, not_dff_output_3;
  
  DFlipFlop ff1 (.clk(clk), .d(x ^ dff_output_1), .q(dff_output_1));
  DFlipFlop ff2 (.clk(clk), .d(x & ~dff_output_2), .q(dff_output_2));
  DFlipFlop ff3 (.clk(clk), .d(x | ~dff_output_3), .q(dff_output_3));
  
  assign not_dff_output_1 = ~dff_output_1;
  assign not_dff_output_2 = ~dff_output_2;
  assign not_dff_output_3 = ~dff_output_3;
  
  assign z = ~(dff_output_1 | dff_output_2 | dff_output_3);
endmodule