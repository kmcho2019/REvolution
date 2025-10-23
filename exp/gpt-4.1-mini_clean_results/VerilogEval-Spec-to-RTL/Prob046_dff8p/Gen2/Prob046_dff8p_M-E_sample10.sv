module DFF(input clk, input reset, input d, output reg q);
  always @(negedge clk) begin
    if (reset)
      q <= 1'b0;
    else
      q <= d;
  end
endmodule

module TopModule(input clk, input reset, input [7:0] d, output [7:0] q);
  wire [7:0] reset_value = 8'h34;
  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin : dffs
      wire d_in = d[i];
      wire reset_bit = reset ? 1'b1 : 1'b0; // synchronous reset signal
      wire q_bit;
      DFF dff_inst(.clk(clk), .reset(reset_bit), .d(d_in), .q(q_bit));
      assign q[i] = reset ? reset_value[i] : q_bit;
    end
  endgenerate
endmodule