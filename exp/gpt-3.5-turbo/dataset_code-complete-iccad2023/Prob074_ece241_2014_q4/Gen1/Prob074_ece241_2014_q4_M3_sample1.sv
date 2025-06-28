module TopModule (
  input clk,
  input x,
  output z
);

reg [2:0] d_ff = 3'b000;

assign z = ~(|d_ff);

always @(posedge clk) begin
  d_ff <= {x ^ d_ff[0], x & ~d_ff[1], x | ~d_ff[2]};
end

endmodule