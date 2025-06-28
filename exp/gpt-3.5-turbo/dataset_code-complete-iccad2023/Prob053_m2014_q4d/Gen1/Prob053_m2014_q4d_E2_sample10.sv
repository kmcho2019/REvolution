module DFF_XOR (
  input clk,
  input d,
  output reg q
);

always @(posedge clk) begin
  q <= d;
end

endmodule

module TopModule (
  input clk,
  input in,
  output reg out
);

wire xor_input;
assign xor_input = in ^ out;

DFF_XOR dff_xor (
  .clk(clk),
  .d(xor_input),
  .q(out)
);

endmodule