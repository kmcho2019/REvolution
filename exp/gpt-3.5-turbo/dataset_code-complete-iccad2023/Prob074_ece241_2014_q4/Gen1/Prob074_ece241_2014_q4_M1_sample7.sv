module TopModule (
  input clk,
  input x,
  output z
);

reg [2:0] d_ff_reg;
reg [2:0] d_ff_next;
wire xor_out, and_out, or_out;

assign xor_out = x ^ d_ff_reg[0];
assign and_out = x & ~d_ff_reg[1];
assign or_out = x | ~d_ff_reg[2];

assign z = ~(xor_out | and_out | or_out);

always @(posedge clk) begin
  d_ff_next[0] <= xor_out;
  d_ff_next[1] <= and_out;
  d_ff_next[2] <= or_out;
  
  d_ff_reg <= d_ff_next;
end

endmodule