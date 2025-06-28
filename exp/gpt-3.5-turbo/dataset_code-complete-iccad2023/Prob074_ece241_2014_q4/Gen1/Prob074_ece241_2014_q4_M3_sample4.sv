module TopModule (
  input clk,
  input x,
  output reg z
);

reg d1, d2, d3;
reg [2:0] flip_flop_outputs;
wire d_flip_flop_1, d_flip_flop_2, d_flip_flop_3;

assign d1 = x ^ flip_flop_outputs[0];
assign d2 = ~(x & flip_flop_outputs[1]);
assign d3 = ~flip_flop_outputs[2];

always @(posedge clk) begin
  flip_flop_outputs <= {d1, d2, d3};
end

assign d_flip_flop_1 = x ^ flip_flop_outputs[0];
assign d_flip_flop_2 = ~(x & flip_flop_outputs[1]);
assign d_flip_flop_3 = ~flip_flop_outputs[2];

assign z = ~(d_flip_flop_1 | d_flip_flop_2 | d_flip_flop_3);

endmodule